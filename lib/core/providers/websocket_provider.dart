import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:async';
import 'dart:convert';
import 'package:barberku_app/core/constants/app_constants.dart';
import 'package:barberku_app/core/utils/logger.dart';

enum ConnectionStatus { disconnected, connecting, connected, reconnecting }

class WebSocketState {
  final ConnectionStatus status;
  final String? error;
  final List<dynamic> queueSnapshot;
  
  const WebSocketState({
    this.status = ConnectionStatus.disconnected,
    this.error,
    this.queueSnapshot = const [],
  });
  
  WebSocketState copyWith({
    ConnectionStatus? status,
    String? error,
    List<dynamic>? queueSnapshot,
  }) {
    return WebSocketState(
      status: status ?? this.status,
      error: error,
      queueSnapshot: queueSnapshot ?? this.queueSnapshot,
    );
  }
}

class WebSocketNotifier extends StateNotifier<WebSocketState> {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  WebSocketNotifier() : super(const WebSocketState());

  void connect() {
    if (state.status == ConnectionStatus.connected) return;

    _attemptConnection();
  }

  void _attemptConnection() {
    try {
      if (_reconnectAttempts == 0) {
        state = state.copyWith(status: ConnectionStatus.connecting);
      } else {
        state = state.copyWith(status: ConnectionStatus.reconnecting);
      }

      _channel = WebSocketChannel.connect(
        Uri.parse(AppConstants.wsUrl),
      );

      _subscription = _channel!.stream.listen(
        (dynamic message) {
          _handleMessage(message as String);
        },
        onError: (error) {
          AppLogger.e('WebSocket error: $error');
          state = state.copyWith(
            status: ConnectionStatus.disconnected,
            error: error.toString(),
          );
          _scheduleReconnect();
        },
        onDone: () {
          AppLogger.w('WebSocket connection closed');
          state = state.copyWith(status: ConnectionStatus.disconnected);
          _scheduleReconnect();
        },
        cancelOnError: false,
      );

      _reconnectAttempts = 0;
      state = state.copyWith(
        status: ConnectionStatus.connected,
        error: null,
      );
    } catch (e) {
      AppLogger.e('Failed to connect: $e');
      state = state.copyWith(
        status: ConnectionStatus.disconnected,
        error: e.toString(),
      );
      _scheduleReconnect();
    }
  }

  void _handleMessage(String message) {
    try {
      final data = jsonDecode(message) as Map<String, dynamic>;
      final event = data['event'] as String?;
      final eventData = data['data'];

      if (event == AppConstants.wsEventQueueUpdate && eventData is List) {
        state = state.copyWith(queueSnapshot: eventData);
      }
    } catch (e) {
      AppLogger.e('Error parsing WebSocket message: $e');
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      AppLogger.w('Max reconnect attempts reached');
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);
    AppLogger.i('Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, _attemptConnection);
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close(status.normalClosure);
    _channel = null;
    _subscription = null;
    _reconnectAttempts = 0;
    state = const WebSocketState(status: ConnectionStatus.disconnected);
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}

final webSocketProvider = StateNotifierProvider<WebSocketNotifier, WebSocketState>((ref) {
  return WebSocketNotifier();
});

final queueStreamProvider = StreamProvider<List<dynamic>>((ref) {
  final wsState = ref.watch(webSocketProvider);
  
  return Stream.fromIterable([wsState.queueSnapshot]).asyncMap((snapshot) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return snapshot;
  });
});

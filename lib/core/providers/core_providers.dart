import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:barberku_app/core/constants/app_constants.dart';

final webSocketChannelProvider = Provider<WebSocketChannel?>((ref) {
  return null;
});

final webSocketConnectionProvider = StateNotifierProvider<WebSocketNotifier, WebSocketState>((ref) {
  return WebSocketNotifier();
});

class WebSocketState {
  final bool isConnected;
  final String? error;
  
  const WebSocketState({
    this.isConnected = false,
    this.error,
  });
  
  WebSocketState copyWith({
    bool? isConnected,
    String? error,
  }) {
    return WebSocketState(
      isConnected: isConnected ?? this.isConnected,
      error: error ?? this.error,
    );
  }
}

class WebSocketNotifier extends StateNotifier<WebSocketState> {
  WebSocketChannel? _channel;
  
  WebSocketNotifier() : super(const WebSocketState());
  
  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(AppConstants.wsUrl));
      state = const WebSocketState(isConnected: true);
    } catch (e) {
      state = WebSocketState(isConnected: false, error: e.toString());
    }
  }
  
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    state = const WebSocketState(isConnected: false);
  }
  
  void sendMessage(Map<String, dynamic> message) {
    _channel?.sink.add(message);
  }
}

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

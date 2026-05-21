import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/providers/websocket_provider.dart';

class TurnNotificationState {
  final bool isCalled;
  final String? queueId;
  final String? customerName;
  final String? barberName;
  final int? queueNumber;
  
  const TurnNotificationState({
    this.isCalled = false,
    this.queueId,
    this.customerName,
    this.barberName,
    this.queueNumber,
  });
  
  TurnNotificationState copyWith({
    bool? isCalled,
    String? queueId,
    String? customerName,
    String? barberName,
    int? queueNumber,
  }) {
    return TurnNotificationState(
      isCalled: isCalled ?? this.isCalled,
      queueId: queueId ?? this.queueId,
      customerName: customerName ?? this.customerName,
      barberName: barberName ?? this.barberName,
      queueNumber: queueNumber ?? this.queueNumber,
    );
  }
}

class TurnNotificationNotifier extends StateNotifier<TurnNotificationState> {
  TurnNotificationNotifier(this.ref) : super(const TurnNotificationState()) {
    _listenToWebSocket();
  }

  final Ref ref;
  
  void _listenToWebSocket() {
    ref.listen<WebSocketState>(webSocketProvider, (previous, next) {
      if (next.status == ConnectionStatus.connected && next.queueSnapshot.isNotEmpty) {
        _checkForCalledQueue(next.queueSnapshot);
      }
    });
  }

  void _checkForCalledQueue(List<dynamic> queues) {
    for (final queue in queues) {
      final status = queue['status'] as String?;
      final isMine = queue['is_mine'] as bool? ?? false;
      
      if (status == 'called' && isMine && !state.isCalled) {
        state = TurnNotificationState(
          isCalled: true,
          queueId: queue['id'] as String?,
          customerName: queue['customer_name'] as String?,
          barberName: queue['barber_name'] as String?,
          queueNumber: queue['queue_number'] as int?,
        );
        break;
      }
    }
  }

  void dismiss() {
    state = const TurnNotificationState(isCalled: false);
  }
}

final turnNotificationProvider = StateNotifierProvider<TurnNotificationNotifier, TurnNotificationState>((ref) {
  return TurnNotificationNotifier(ref);
});

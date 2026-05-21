import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/providers/websocket_provider.dart';

final activeQueueProvider = Provider<bool>((ref) {
  final wsState = ref.watch(webSocketProvider);
  
  if (wsState.queueSnapshot.isEmpty) return false;
  
  for (final queue in wsState.queueSnapshot) {
    final isMine = queue['is_mine'] as bool? ?? false;
    final status = queue['status'] as String?;
    
    if (isMine && (status == 'waiting' || status == 'called' || status == 'in_progress')) {
      return true;
    }
  }
  
  return false;
});

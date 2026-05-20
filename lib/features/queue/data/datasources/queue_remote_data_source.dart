import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:barberku_app/core/constants/app_constants.dart';
import 'package:barberku_app/core/utils/logger.dart';
import 'package:barberku_app/features/queue/data/models/queue_model.dart';

class QueueRemoteDataSource {
  final WebSocketChannel channel;
  final StreamController<List<QueueModel>> _queueStreamController = StreamController<List<QueueModel>>.broadcast();
  
  QueueRemoteDataSource(this.channel) {
    _listenToWebSocket();
  }
  
  Stream<List<QueueModel>> get queueStream => _queueStreamController.stream;
  
  void _listenToWebSocket() {
    channel.stream.listen(
      (dynamic message) {
        try {
          final data = jsonDecode(message as String) as Map<String, dynamic>;
          if (data['event'] == AppConstants.wsEventQueueUpdate) {
            final queueData = data['data'] as List<dynamic>;
            final queues = queueData
                .map((e) => QueueModel.fromJson(e as Map<String, dynamic>))
                .toList();
            _queueStreamController.add(queues);
          }
        } catch (e) {
          AppLogger.e('Error parsing WebSocket message: $e');
        }
      },
      onError: (error) {
        AppLogger.e('WebSocket error: $error');
      },
      onDone: () {
        AppLogger.w('WebSocket connection closed');
      },
    );
  }
  
  void dispose() {
    _queueStreamController.close();
  }
}

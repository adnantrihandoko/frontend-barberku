import 'dart:async';
import 'package:barberku_app/features/queue/data/models/queue_model.dart';

class QueueRemoteDataSource {
  final StreamController<List<QueueModel>> _queueStreamController = StreamController<List<QueueModel>>.broadcast();
  
  QueueRemoteDataSource();
  
  Stream<List<QueueModel>> get queueStream => _queueStreamController.stream;
  
  void updateFromWebSocket(List<dynamic> queueData) {
    try {
      final queues = queueData
          .map((e) => QueueModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _queueStreamController.add(queues);
    } catch (e) {
      // Handle error
    }
  }
  
  void dispose() {
    _queueStreamController.close();
  }
}

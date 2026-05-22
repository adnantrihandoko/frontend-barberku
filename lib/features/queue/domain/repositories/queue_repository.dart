import 'package:barberku_app/features/queue/domain/entities/queue_entity.dart';

abstract class QueueRepository {
  Future<List<QueueEntity>> getQueueList();
  Future<QueueEntity> joinQueue({
    required String customerId,
    required String customerName,
    required String serviceId,
    required String serviceName,
    String? barberId,
  });
  Future<void> cancelQueue(String queueId);
  Future<QueueEntity> getQueueDetail(String queueId);
  Stream<List<QueueEntity>> watchQueueList();
  Future<QueueEntity> callQueue(String queueId);
  Future<QueueEntity> serveQueue(String queueId);
  Future<QueueEntity> completeQueue(String queueId);
  Future<QueueEntity> skipQueue(String queueId);
  Future<QueueEntity> addWalkIn({
    required String customerName,
    required String serviceId,
    required String serviceName,
    String? barberId,
    String? customerId,
  });
}

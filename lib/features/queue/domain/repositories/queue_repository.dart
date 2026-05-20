import 'package:barberku_app/features/queue/domain/entities/queue_entity.dart';

abstract class QueueRepository {
  Future<List<QueueEntity>> getQueueList();
  Future<QueueEntity> joinQueue({
    required String customerId,
    required String serviceId,
    String? barberId,
  });
  Future<void> cancelQueue(String queueId);
  Future<QueueEntity> getQueueDetail(String queueId);
  Stream<List<QueueEntity>> watchQueueList();
}

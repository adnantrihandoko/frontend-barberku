import 'package:barberku_app/features/queue/domain/entities/queue_entity.dart';
import 'package:barberku_app/features/queue/domain/repositories/queue_repository.dart';

class GetQueueList {
  final QueueRepository repository;
  
  GetQueueList(this.repository);
  
  Future<List<QueueEntity>> call() async {
    return repository.getQueueList();
  }
}

class JoinQueue {
  final QueueRepository repository;
  
  JoinQueue(this.repository);
  
  Future<QueueEntity> call({
    required String customerId,
    required String serviceId,
    String? barberId,
  }) async {
    return repository.joinQueue(
      customerId: customerId,
      serviceId: serviceId,
      barberId: barberId,
    );
  }
}

class CancelQueue {
  final QueueRepository repository;
  
  CancelQueue(this.repository);
  
  Future<void> call(String queueId) async {
    return repository.cancelQueue(queueId);
  }
}

class GetQueueDetail {
  final QueueRepository repository;
  
  GetQueueDetail(this.repository);
  
  Future<QueueEntity> call(String queueId) async {
    return repository.getQueueDetail(queueId);
  }
}

class WatchQueueList {
  final QueueRepository repository;
  
  WatchQueueList(this.repository);
  
  Stream<List<QueueEntity>> call() {
    return repository.watchQueueList();
  }
}

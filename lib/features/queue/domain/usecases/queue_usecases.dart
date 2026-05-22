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
    required String customerName,
    required String serviceId,
    required String serviceName,
    String? barberId,
  }) async {
    return repository.joinQueue(
      customerId: customerId,
      customerName: customerName,
      serviceId: serviceId,
      serviceName: serviceName,
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

class CallQueue {
  final QueueRepository repository;

  CallQueue(this.repository);

  Future<QueueEntity> call(String queueId) async {
    return repository.callQueue(queueId);
  }
}

class ServeQueue {
  final QueueRepository repository;

  ServeQueue(this.repository);

  Future<QueueEntity> call(String queueId) async {
    return repository.serveQueue(queueId);
  }
}

class CompleteQueue {
  final QueueRepository repository;

  CompleteQueue(this.repository);

  Future<QueueEntity> call(String queueId) async {
    return repository.completeQueue(queueId);
  }
}

class SkipQueue {
  final QueueRepository repository;

  SkipQueue(this.repository);

  Future<QueueEntity> call(String queueId) async {
    return repository.skipQueue(queueId);
  }
}

class AddWalkIn {
  final QueueRepository repository;

  AddWalkIn(this.repository);

  Future<QueueEntity> call({
    required String customerName,
    required String serviceId,
    required String serviceName,
    String? barberId,
    String? customerId,
  }) async {
    return repository.addWalkIn(
      customerName: customerName,
      serviceId: serviceId,
      serviceName: serviceName,
      barberId: barberId,
      customerId: customerId,
    );
  }
}

import 'package:barberku_app/features/queue/data/datasources/queue_remote_data_source.dart';
import 'package:barberku_app/features/queue/data/models/queue_model.dart';
import 'package:barberku_app/features/queue/domain/entities/queue_entity.dart';
import 'package:barberku_app/features/queue/domain/repositories/queue_repository.dart';

class QueueRepositoryImpl implements QueueRepository {
  final QueueRemoteDataSource remoteDataSource;
  List<QueueModel> _cachedQueues = [];

  QueueRepositoryImpl({required this.remoteDataSource}) {
    remoteDataSource.queueStream.listen((queues) {
      _cachedQueues = queues;
    });
  }

  @override
  Future<List<QueueEntity>> getQueueList() async {
    return _cachedQueues.map((model) => model.toEntity()).toList();
  }

  @override
  Future<QueueEntity> joinQueue({
    required String customerId,
    required String customerName,
    required String serviceId,
    required String serviceName,
    String? barberId,
  }) async {
    final model = await remoteDataSource.joinQueue(
      customerId: customerId,
      customerName: customerName,
      serviceId: serviceId,
      serviceName: serviceName,
      barberId: barberId,
    );
    return model.toEntity();
  }

  @override
  Future<void> cancelQueue(String queueId) async {
    await remoteDataSource.cancelQueue(queueId);
  }

  @override
  Future<QueueEntity> getQueueDetail(String queueId) async {
    final model = await remoteDataSource.getQueueDetail(queueId);
    return model.toEntity();
  }

  @override
  Stream<List<QueueEntity>> watchQueueList() {
    return remoteDataSource.queueStream.map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<QueueEntity> callQueue(String queueId) async {
    final model = await remoteDataSource.callQueue(queueId);
    return model.toEntity();
  }

  @override
  Future<QueueEntity> serveQueue(String queueId) async {
    final model = await remoteDataSource.serveQueue(queueId);
    return model.toEntity();
  }

  @override
  Future<QueueEntity> completeQueue(String queueId) async {
    final model = await remoteDataSource.completeQueue(queueId);
    return model.toEntity();
  }

  @override
  Future<QueueEntity> skipQueue(String queueId) async {
    await remoteDataSource.skipQueue(queueId);
    final model = _cachedQueues.firstWhere(
      (q) => q.id == queueId,
      orElse: () => throw Exception('Queue not found'),
    );
    return model.toEntity();
  }

  @override
  Future<QueueEntity> addWalkIn({
    required String customerName,
    required String serviceId,
    required String serviceName,
    String? barberId,
    String? customerId,
  }) async {
    final model = await remoteDataSource.addWalkIn(
      customerName: customerName,
      serviceId: serviceId,
      serviceName: serviceName,
      barberId: barberId,
    );
    return model.toEntity();
  }
}

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
    required String serviceId,
    String? barberId,
  }) async {
    final model = QueueModel(
      id: '',
      queueNumber: 0,
      customerId: customerId,
      customerName: '',
      serviceId: serviceId,
      serviceName: '',
      status: 'waiting',
      position: 0,
      createdAt: DateTime.now(),
    );
    return model.toEntity();
  }
  
  @override
  Future<void> cancelQueue(String queueId) async {
  }
  
  @override
  Future<QueueEntity> getQueueDetail(String queueId) async {
    final model = _cachedQueues.firstWhere(
      (q) => q.id == queueId,
      orElse: () => throw Exception('Queue not found'),
    );
    return model.toEntity();
  }
  
  @override
  Stream<List<QueueEntity>> watchQueueList() {
    return remoteDataSource.queueStream.map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }
}

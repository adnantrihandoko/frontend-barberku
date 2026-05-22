import 'dart:async';
import 'package:dio/dio.dart';
import 'package:barberku_app/core/constants/app_constants.dart';
import 'package:barberku_app/features/queue/data/models/queue_model.dart';

class QueueRemoteDataSource {
  final Dio dio;
  final StreamController<List<QueueModel>> _queueStreamController =
      StreamController<List<QueueModel>>.broadcast();

  QueueRemoteDataSource({required this.dio});

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

  Future<QueueModel> joinQueue({
    required String customerId,
    required String customerName,
    required String serviceId,
    required String serviceName,
    String? barberId,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}/join',
        data: {
          'customer_id': customerId,
          'customer_name': customerName,
          'service_id': serviceId,
          'service_name': serviceName,
          if (barberId != null) 'barber_id': barberId,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QueueModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to join queue');
    }
  }

  Future<QueueModel> callQueue(String queueId) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}/$queueId/call',
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QueueModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to call queue');
    }
  }

  Future<QueueModel> serveQueue(String queueId) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}/$queueId/serve',
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QueueModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to serve queue');
    }
  }

  Future<QueueModel> completeQueue(String queueId) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}/$queueId/complete',
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QueueModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ?? 'Failed to complete queue',
      );
    }
  }

  Future<void> cancelQueue(String queueId) async {
    try {
      await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}/$queueId/cancel',
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to cancel queue');
    }
  }

  Future<void> skipQueue(String queueId) async {
    try {
      await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}/$queueId/skip',
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to skip queue');
    }
  }

  Future<QueueModel> addWalkIn({
    required String customerName,
    required String serviceId,
    required String serviceName,
    String? barberId,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}/walk-in',
        data: {
          'customer_name': customerName,
          'service_id': serviceId,
          'service_name': serviceName,
          if (barberId != null) 'barber_id': barberId,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QueueModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to add walk-in');
    }
  }

  Future<List<QueueModel>> fetchQueueList() async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}',
      );
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => QueueModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ?? 'Failed to fetch queue list',
      );
    }
  }

  Future<QueueModel> getQueueDetail(String queueId) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.apiQueue}/$queueId',
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QueueModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ?? 'Failed to get queue detail',
      );
    }
  }

  void dispose() {
    _queueStreamController.close();
  }
}

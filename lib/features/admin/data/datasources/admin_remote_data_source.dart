import 'package:dio/dio.dart';
import 'package:barberku_app/core/constants/app_constants.dart';
import 'package:barberku_app/core/utils/logger.dart';
import 'package:barberku_app/features/admin/data/models/service_model.dart';
import 'package:barberku_app/features/admin/data/models/barber_model.dart';
import 'package:barberku_app/features/admin/data/models/settings_model.dart';
import 'package:barberku_app/features/admin/data/models/stats_model.dart';

class AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSource({required this.dio});

  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await dio.get('${AppConstants.baseUrl}${AppConstants.apiServices}');
      final data = response.data['data'] as List;
      return data.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      AppLogger.e('getServices failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat layanan');
    }
  }

  Future<ServiceModel> createService({
    required String name,
    required String description,
    required double price,
    required int duration,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiServices}',
        data: {
          'name': name,
          'description': description,
          'price': price,
          'duration': duration,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return ServiceModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('createService failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal membuat layanan');
    }
  }

  Future<ServiceModel> updateService({
    required String id,
    required String name,
    required String description,
    required double price,
    required int duration,
    required bool isActive,
  }) async {
    try {
      final response = await dio.put(
        '${AppConstants.baseUrl}${AppConstants.apiServices}/$id',
        data: {
          'name': name,
          'description': description,
          'price': price,
          'duration': duration,
          'is_active': isActive,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return ServiceModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('updateService failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal memperbarui layanan');
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await dio.delete('${AppConstants.baseUrl}${AppConstants.apiServices}/$id');
    } on DioException catch (e) {
      AppLogger.e('deleteService failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus layanan');
    }
  }

  Future<List<BarberModel>> getBarbers() async {
    try {
      final response = await dio.get('${AppConstants.baseUrl}${AppConstants.apiBarbers}');
      final data = response.data['data'] as List;
      return data.map((e) => BarberModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      AppLogger.e('getBarbers failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat barber');
    }
  }

  Future<BarberModel> createBarber({
    required String name,
    required String specialty,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiBarbers}',
        data: {
          'name': name,
          'specialty': specialty,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return BarberModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('createBarber failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal membuat barber');
    }
  }

  Future<BarberModel> updateBarber({
    required String id,
    required String name,
    required String specialty,
    required bool isActive,
  }) async {
    try {
      final response = await dio.put(
        '${AppConstants.baseUrl}${AppConstants.apiBarbers}/$id',
        data: {
          'name': name,
          'specialty': specialty,
          'is_active': isActive,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return BarberModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('updateBarber failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal memperbarui barber');
    }
  }

  Future<void> deleteBarber(String id) async {
    try {
      await dio.delete('${AppConstants.baseUrl}${AppConstants.apiBarbers}/$id');
    } on DioException catch (e) {
      AppLogger.e('deleteBarber failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus barber');
    }
  }

  Future<SettingsModel> getSettings() async {
    try {
      final response = await dio.get('${AppConstants.baseUrl}${AppConstants.apiSettings}');
      final data = response.data['data'] as Map<String, dynamic>;
      return SettingsModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('getSettings failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat pengaturan');
    }
  }

  Future<SettingsModel> updateSettings({
    required int openHour,
    required int closeHour,
    required int maxQueueSize,
  }) async {
    try {
      final response = await dio.put(
        '${AppConstants.baseUrl}${AppConstants.apiSettings}',
        data: {
          'open_hour': openHour,
          'close_hour': closeHour,
          'max_queue_size': maxQueueSize,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return SettingsModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('updateSettings failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal memperbarui pengaturan');
    }
  }

  Future<StatsModel> getStats() async {
    try {
      final response = await dio.get('${AppConstants.baseUrl}${AppConstants.apiStats}');
      final data = response.data['data'] as Map<String, dynamic>;
      return StatsModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('getStats failed: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal memuat statistik');
    }
  }
}

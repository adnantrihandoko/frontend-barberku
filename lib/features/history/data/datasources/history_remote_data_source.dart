import 'package:dio/dio.dart';
import 'package:barberku_app/core/constants/app_constants.dart';
import 'package:barberku_app/features/history/data/models/history_model.dart';

class HistoryRemoteDataSource {
  final Dio dio;

  HistoryRemoteDataSource({required this.dio});

  Future<List<HistoryModel>> getHistory({required String customerId}) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.apiHistory}',
        queryParameters: {'customer_id': customerId},
      );

      final data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Gagal memuat riwayat');
    }
  }

  Future<void> rateService({
    required String queueId,
    required int rating,
    String? comment,
  }) async {
    try {
      await dio.post(
        '${AppConstants.baseUrl}${AppConstants.apiHistory}/$queueId/rate',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Gagal memberi rating');
    }
  }
}

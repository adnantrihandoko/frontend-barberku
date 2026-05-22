import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:barberku_app/features/history/data/datasources/history_remote_data_source.dart';
import 'package:barberku_app/features/history/data/models/history_model.dart';

final historyRemoteDataSourceProvider = Provider<HistoryRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return HistoryRemoteDataSource(dio: dio);
});

final getHistoryProvider = FutureProvider.family<List<HistoryModel>, String>((ref, customerId) {
  final dataSource = ref.watch(historyRemoteDataSourceProvider);
  return dataSource.getHistory(customerId: customerId);
});

final rateServiceProvider = Provider<RateService>((ref) {
  final dataSource = ref.watch(historyRemoteDataSourceProvider);
  return RateService(dataSource);
});

class RateService {
  final HistoryRemoteDataSource _dataSource;

  RateService(this._dataSource);

  Future<void> call({
    required String queueId,
    required int rating,
    String? comment,
  }) {
    return _dataSource.rateService(
      queueId: queueId,
      rating: rating,
      comment: comment,
    );
  }
}

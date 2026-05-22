import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:barberku_app/core/constants/app_constants.dart';
import 'package:barberku_app/features/auth/presentation/providers/auth_provider.dart';

final fcmRegisterProvider = AsyncNotifierProvider<FCMRegisterNotifier, void>(() {
  return FCMRegisterNotifier();
});

class FCMRegisterNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> registerToken(String token, String platform) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioProvider);
      final storage = ref.read(storageProvider);
      final authToken = await storage.read(key: AppConstants.keyAuthToken);
      await dio.post(
        '${AppConstants.baseUrl}/api/v1/fcm/register',
        options: Options(headers: {
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        }),
        data: {'token': token, 'platform': platform},
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

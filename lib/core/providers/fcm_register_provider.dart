import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/features/auth/presentation/providers/auth_provider.dart';

final fcmRegisterProvider = AsyncNotifierProvider<FCMRegisterNotifier, void>(() {
  return FCMRegisterNotifier();
});

class FCMRegisterNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> registerToken(String token, String platform) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/fcm/register', data: {
        'token': token,
        'platform': platform,
      });
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

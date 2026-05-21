import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/services/fcm_service.dart';

final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService();
});

final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final fcmService = ref.watch(fcmServiceProvider);
  return fcmService.getToken();
});

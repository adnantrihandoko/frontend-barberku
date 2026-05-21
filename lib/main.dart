import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:barberku_app/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  final fcmService = FCMService();
  await fcmService.initialize();
  
  runApp(
    ProviderScope(
      overrides: [
        fcmServiceProvider.overrideWithValue(fcmService),
      ],
      child: const BarberKuApp(),
    ),
  );
}

class BarberKuApp extends ConsumerWidget {
  const BarberKuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}

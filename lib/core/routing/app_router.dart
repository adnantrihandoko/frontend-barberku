import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:barberku_app/features/auth/presentation/screens/admin_login_screen.dart';
import 'package:barberku_app/features/admin/admin.dart';
import 'package:barberku_app/core/routing/home_screen.dart';

part 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.queue,
            name: 'queue',
            builder: (context, state) => const QueueScreen(),
          ),
          GoRoute(
            path: AppRoutes.history,
            name: 'history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.queueDetail,
        name: 'queue-detail',
        builder: (context, state) {
          final queueId = state.pathParameters['id'] ?? '';
          return QueueDetailScreen(queueId: queueId);
        },
      ),
    ],
  );
}

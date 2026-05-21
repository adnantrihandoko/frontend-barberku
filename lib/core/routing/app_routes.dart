part of 'app_router.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String queue = '/queue';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String queueDetail = '/queue/:id';
}

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _getCurrentIndex(context);
    final hasActiveQueue = ref.watch(activeQueueProvider);
    
    return ResponsiveNavigation(
      currentIndex: currentIndex,
      hasActiveQueue: hasActiveQueue,
      onDestinationSelected: (index) => _onItemTapped(context, index),
      child: child,
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.queue)) return 1;
    if (location.startsWith(AppRoutes.history)) return 2;
    if (location.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.queue);
      case 2:
        context.go(AppRoutes.history);
      case 3:
        context.go(AppRoutes.profile);
    }
  }
}

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Queue Screen'),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const history_feature.HistoryScreen();
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}

class QueueDetailScreen extends StatelessWidget {
  final String queueId;
  const QueueDetailScreen({super.key, required this.queueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue Detail'),
      ),
      body: Center(
        child: Text('Queue Detail: $queueId'),
      ),
    );
  }
}

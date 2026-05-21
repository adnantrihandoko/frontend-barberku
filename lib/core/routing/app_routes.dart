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

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const FloatingBottomNavBar(),
    );
  }
}

class FloatingBottomNavBar extends StatelessWidget {
  const FloatingBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered_outlined),
              activeIcon: Icon(Icons.format_list_numbered),
              label: 'My Queue',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
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
    return const Scaffold(
      body: Center(
        child: Text('History Screen'),
      ),
    );
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

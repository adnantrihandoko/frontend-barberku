import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barberku_app/core/core.dart';
import 'package:barberku_app/features/admin/presentation/widgets/admin_queue_list.dart';
import 'package:barberku_app/features/admin/presentation/widgets/walk_in_dialog.dart';
import 'package:barberku_app/features/admin/presentation/screens/service_management_screen.dart';
import 'package:barberku_app/features/admin/presentation/screens/barber_management_screen.dart';
import 'package:barberku_app/features/admin/presentation/screens/store_settings_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCallNext() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Memanggil antrian berikutnya...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onAddWalkIn() {
    showDialog(
      context: context,
      builder: (context) => const WalkInDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_android),
            onPressed: _onCallNext,
            tooltip: 'Panggil Berikutnya',
          ),
          IconButton(
            icon: const Icon(Icons.content_cut),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ServiceManagementScreen(),
                ),
              );
            },
            tooltip: 'Manajemen Layanan',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BarberManagementScreen(),
                ),
              );
            },
            tooltip: 'Manajemen Barber',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const StoreSettingsScreen(),
                ),
              );
            },
            tooltip: 'Pengaturan Toko',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go(AppRoutes.login);
            },
            tooltip: 'Logout',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Menunggu', icon: Icon(Icons.schedule)),
            Tab(text: 'Dilayani', icon: Icon(Icons.content_cut)),
            Tab(text: 'Selesai', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AdminQueueList(status: 'waiting', onCallNext: _onCallNext),
          AdminQueueList(status: 'in_progress'),
          AdminQueueList(status: 'completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddWalkIn,
        icon: const Icon(Icons.person_add),
        label: const Text('Walk-In'),
      ),
    );
  }
}

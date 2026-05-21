import 'package:flutter/material.dart';
import 'package:barberku_app/core/core.dart';
import 'package:barberku_app/features/customer/presentation/widgets/join_queue_bottom_sheet.dart';
import 'package:barberku_app/features/customer/presentation/widgets/customer_queue_list.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  Map<String, dynamic>? _activeQueue;

  void _onJoinQueue() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const JoinQueueBottomSheet(),
    );

    if (result != null && mounted) {
      setState(() {
        _activeQueue = result;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Antrian #${result['queueNumber']} berhasil! ${result['service'].name}',
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _onViewMyQueue() {
    if (_activeQueue != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Posisi Anda: #${_activeQueue!['queueNumber']}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.login);
            },
            tooltip: 'Login Admin',
          ),
        ],
      ),
      body: _activeQueue != null
          ? _buildActiveQueueView()
          : _buildJoinQueueView(),
    );
  }

  Widget _buildJoinQueueView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.content_cut,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Selamat Datang di BarberKu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ambil antrian dari mana saja, tidak perlu menunggu di tempat',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onJoinQueue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 4,
                    ),
                    child: const Text(
                      'Ambil Antrian',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Antrian Saat Ini',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const CustomerQueueList(),
        ],
      ),
    );
  }

  Widget _buildActiveQueueView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          '#5',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Antrian Anda',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          Text(
                            _activeQueue!['service'].name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_activeQueue!['barber'] != null)
                            Text(
                              'Barber: ${_activeQueue!['barber'].name}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatusInfo(
                      icon: Icons.schedule,
                      label: 'Status',
                      value: 'Menunggu',
                    ),
                    _StatusInfo(
                      icon: Icons.timer,
                      label: 'Estimasi',
                      value: '15 menit',
                    ),
                    _StatusInfo(
                      icon: Icons.format_list_numbered,
                      label: 'Posisi',
                      value: '#3',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _onViewMyQueue,
                        icon: const Icon(Icons.visibility),
                        label: const Text('Lihat Antrian'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _activeQueue = null;
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Batalkan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Antrian Lainnya',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const CustomerQueueList(),
        ],
      ),
    );
  }
}

class _StatusInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatusInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

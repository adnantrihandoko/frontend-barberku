import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/theme/app_colors.dart';
import 'package:barberku_app/features/admin/presentation/widgets/admin_queue_card.dart';

class AdminQueueList extends ConsumerWidget {
  final String status;
  final VoidCallback? onCallNext;

  const AdminQueueList({
    super.key,
    required this.status,
    this.onCallNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queues = _getDummyQueues();
    final filteredQueues = queues.where((q) => q['status'] == status).toList();

    if (filteredQueues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada antrian ${_getStatusText(status)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredQueues.length,
      itemBuilder: (context, index) {
        final queue = filteredQueues[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key(queue['id'] as String),
            background: _buildBackground(
              context,
              Icons.phone,
              Colors.green,
              alignment: Alignment.centerLeft,
            ),
            secondaryBackground: _buildBackground(
              context,
              Icons.skip_next,
              Colors.orange,
              alignment: Alignment.centerRight,
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                return await _showConfirmDialog(context, 'Panggil antrian ini?');
              } else if (direction == DismissDirection.endToStart) {
                return await _showConfirmDialog(context, 'Tandai sebagai no-show (lewati)?');
              }
              return false;
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Antrian #${queue['queue_number']} dipanggil'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                onCallNext?.call();
              } else if (direction == DismissDirection.endToStart) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Antrian #${queue['queue_number']} dilewati'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: AdminQueueCard(
              queueNumber: queue['queue_number'] as int,
              customerName: queue['customer_name'] as String,
              serviceName: queue['service_name'] as String,
              status: queue['status'] as String,
              createdAt: queue['created_at'] as DateTime,
              barberName: queue['barber_name'] as String?,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackground(
    BuildContext context,
    IconData icon,
    Color color, {
    required Alignment alignment,
  }) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: Colors.white),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return 'menunggu';
      case 'in_progress':
        return 'dilayani';
      case 'completed':
        return 'selesai';
      default:
        return status;
    }
  }

  List<Map<String, dynamic>> _getDummyQueues() {
    return [
      {
        'id': '1',
        'queue_number': 1,
        'customer_name': 'Budi Santoso',
        'service_name': 'Potong Rambut',
        'status': 'waiting',
        'created_at': DateTime.now().subtract(const Duration(minutes: 15)),
        'barber_name': 'Andi',
      },
      {
        'id': '2',
        'queue_number': 2,
        'customer_name': 'Siti Aminah',
        'service_name': 'Cuci & Potong',
        'status': 'waiting',
        'created_at': DateTime.now().subtract(const Duration(minutes: 10)),
        'barber_name': null,
      },
      {
        'id': '3',
        'queue_number': 3,
        'customer_name': 'Ahmad Rizki',
        'service_name': 'Potong Jenggot',
        'status': 'in_progress',
        'created_at': DateTime.now().subtract(const Duration(minutes: 30)),
        'barber_name': 'Budi',
      },
      {
        'id': '4',
        'queue_number': 4,
        'customer_name': 'Dewi Lestari',
        'service_name': 'Potong Rambut',
        'status': 'completed',
        'created_at': DateTime.now().subtract(const Duration(minutes: 45)),
        'barber_name': 'Andi',
      },
    ];
  }
}

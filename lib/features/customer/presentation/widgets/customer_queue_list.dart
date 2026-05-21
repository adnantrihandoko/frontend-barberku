import 'package:flutter/material.dart';
import 'package:barberku_app/core/theme/app_colors.dart';

class CustomerQueueList extends StatelessWidget {
  const CustomerQueueList({super.key});

  @override
  Widget build(BuildContext context) {
    final queues = _getDummyQueues();

    if (queues.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Belum ada antrian saat ini'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: queues.length,
      itemBuilder: (context, index) {
        final queue = queues[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStatusColor(queue['status'] as String)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '#${queue['queue_number']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(queue['status'] as String),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          queue['customer_name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          queue['service_name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(queue['status'] as String)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(queue['status'] as String),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(queue['status'] as String),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return AppColors.secondary;
      case 'called':
        return AppColors.accent;
      case 'in_progress':
        return AppColors.primary;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.textSecondaryLight;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return 'Menunggu';
      case 'called':
        return 'Dipanggil';
      case 'in_progress':
        return 'Dilayani';
      case 'completed':
        return 'Selesai';
      default:
        return status;
    }
  }

  List<Map<String, dynamic>> _getDummyQueues() {
    return [
      {
        'queue_number': 1,
        'customer_name': 'Budi S.',
        'service_name': 'Potong Rambut',
        'status': 'in_progress',
      },
      {
        'queue_number': 2,
        'customer_name': 'Siti A.',
        'service_name': 'Cuci & Potong',
        'status': 'waiting',
      },
      {
        'queue_number': 3,
        'customer_name': 'Ahmad R.',
        'service_name': 'Potong Jenggot',
        'status': 'waiting',
      },
      {
        'queue_number': 4,
        'customer_name': 'Dewi L.',
        'service_name': 'Pewarnaan',
        'status': 'waiting',
      },
    ];
  }
}

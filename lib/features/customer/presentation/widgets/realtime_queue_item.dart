import 'package:flutter/material.dart';
import 'package:barberku_app/core/theme/app_colors.dart';

class RealtimeQueueItem extends StatelessWidget {
  final Map<String, dynamic> queue;
  final bool isMine;

  const RealtimeQueueItem({
    super.key,
    required this.queue,
    this.isMine = false,
  });

  @override
  Widget build(BuildContext context) {
    final queueNumber = queue['queue_number'] ?? 0;
    final customerName = queue['customer_name'] ?? 'Anonim';
    final serviceName = queue['service_name'] ?? '';
    final status = queue['status'] as String? ?? 'waiting';
    final position = queue['position'] ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isMine
            ? AppColors.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isMine
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2)
            : null,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: isMine ? 2 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '#$queueNumber',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isMine ? 'Anda' : _getDisplayName(customerName),
                            style: TextStyle(
                              fontWeight: isMine ? FontWeight.bold : FontWeight.w600,
                              fontSize: 15,
                              color: isMine ? AppColors.primary : null,
                            ),
                          ),
                        ),
                        if (isMine)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Anda',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusText(status),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                  if (position > 0 && !isMine)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '#$position',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
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
      case 'canceled':
      case 'skipped':
        return AppColors.error;
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
      case 'canceled':
        return 'Dibatalkan';
      case 'skipped':
        return 'Dilewati';
      default:
        return status;
    }
  }

  String _getDisplayName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length > 1) {
      return '${parts[0]} ${parts.last[0]}.';
    }
    return fullName;
  }
}

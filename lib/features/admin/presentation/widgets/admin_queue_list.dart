import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/theme/app_colors.dart';
import 'package:barberku_app/features/admin/presentation/widgets/admin_queue_card.dart';
import 'package:barberku_app/features/queue/presentation/providers/queue_provider.dart';

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
    final state = ref.watch(queueListStateProvider);
    final queues = state.queues.where((q) => q.status == status).toList();

    if (state.isLoading && state.queues.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.queues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(state.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(queueListStateProvider.notifier).refresh(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (queues.isEmpty) {
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
      itemCount: queues.length,
      itemBuilder: (context, index) {
        final queue = queues[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key(queue.id),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                if (status != 'waiting') return false;
                return await _showConfirmDialog(context, 'Panggil antrian ini?');
              } else if (direction == DismissDirection.endToStart) {
                if (status != 'waiting') return false;
                return await _showConfirmDialog(context, 'Tandai sebagai no-show (lewati)?');
              }
              return false;
            },
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                try {
                  await ref.read(callQueueProvider).call(queue.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Antrian #${queue.queueNumber} dipanggil'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ref.read(queueListStateProvider.notifier).refresh();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal: $e'), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
                    );
                  }
                }
              } else if (direction == DismissDirection.endToStart) {
                try {
                  await ref.read(skipQueueProvider).call(queue.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Antrian #${queue.queueNumber} dilewati'),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ref.read(queueListStateProvider.notifier).refresh();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal: $e'), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
                    );
                  }
                }
              }
            },
            child: AdminQueueCard(
              queueNumber: queue.queueNumber,
              customerName: queue.customerName,
              serviceName: queue.serviceName,
              status: queue.status,
              createdAt: queue.createdAt,
              barberName: queue.barberId,
              onComplete: status == 'in_progress'
                  ? () async {
                      try {
                        await ref.read(completeQueueProvider).call(queue.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Antrian #${queue.queueNumber} selesai'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal: $e'), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
                          );
                        }
                      }
                    }
                  : null,
            ),
          ),
        );
      },
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
}

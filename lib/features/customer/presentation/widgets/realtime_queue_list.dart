import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/providers/websocket_provider.dart';
import 'package:barberku_app/core/theme/app_colors.dart';
import 'package:barberku_app/features/customer/presentation/widgets/realtime_queue_item.dart';

class RealtimeQueueList extends ConsumerWidget {
  final String? myCustomerId;
  final String? myQueueId;

  const RealtimeQueueList({
    super.key,
    this.myCustomerId,
    this.myQueueId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsState = ref.watch(webSocketProvider);
    final queues = wsState.queueSnapshot;

    if (wsState.status == ConnectionStatus.connecting ||
        wsState.status == ConnectionStatus.reconnecting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Menyambungkan ke server...'),
          ],
        ),
      );
    }

    if (wsState.status == ConnectionStatus.disconnected) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.error.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Menyambungkan kembali...',
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(webSocketProvider.notifier).connect();
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 64, color: AppColors.textSecondaryLight),
                  SizedBox(height: 16),
                  Text('Tidak ada koneksi'),
                ],
              ),
            ),
          ),
        ],
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
              'Belum ada antrian saat ini',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
      );
    }

    final waitingQueues = queues.where((q) {
      final status = q['status'] as String?;
      return status == 'waiting' || status == 'called';
    }).toList();

    final servingQueues = queues.where((q) {
      final status = q['status'] as String?;
      return status == 'in_progress';
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (servingQueues.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Sedang Dilayani',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            ),
            ...servingQueues.map((q) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: RealtimeQueueItem(
                    queue: q,
                    isMine: q['id'] == myQueueId,
                  ),
                )),
            const Divider(height: 32),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Menunggu (${waitingQueues.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
            ),
          ),
          ...waitingQueues.map((q) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: RealtimeQueueItem(
                  queue: q,
                  isMine: q['id'] == myQueueId,
                ),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/core.dart';
import 'package:barberku_app/features/customer/presentation/widgets/join_queue_bottom_sheet.dart';
import 'package:barberku_app/features/customer/presentation/widgets/realtime_queue_list.dart';
import 'package:barberku_app/features/customer/presentation/widgets/customer_queue_list.dart';
import 'package:barberku_app/features/customer/presentation/widgets/called_dialog.dart';
import 'package:barberku_app/features/customer/presentation/widgets/cancel_dialogs.dart';
import 'package:barberku_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:barberku_app/features/queue/presentation/providers/queue_provider.dart';
import 'package:barberku_app/features/queue/domain/entities/queue_entity.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(webSocketProvider.notifier).connect();
    });
  }

  String _customerId() {
    final authState = ref.read(authStateProvider);
    return authState.user?.id ?? 'test-customer-001';
  }

  QueueEntity? _findActiveQueue() {
    final queueState = ref.watch(queueListStateProvider);
    final customerId = _customerId();
    final active = queueState.queues.where((q) =>
      q.customerId == customerId &&
      (q.status == AppConstants.queueStatusWaiting ||
       q.status == AppConstants.queueStatusCalled ||
       q.status == AppConstants.queueStatusInProgress));
    return active.isNotEmpty ? active.first : null;
  }

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
      ref.read(queueListStateProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Antrian #${result['queueNumber']} berhasil! ${(result['service'] as dynamic)?.name ?? ''}',
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

  void _onCancelQueue(QueueEntity activeQueue) async {
    final cancelState = ref.read(cancelProvider);

    if (!cancelState.canCancel) {
      if (cancelState.isInCooldown) {
        showDialog(
          context: context,
          builder: (context) => CooldownDialog(cooldownUntil: cancelState.cooldownUntil!),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => const CancelLimitReachedDialog(),
        );
      }
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => CancelConfirmationDialog(
        remainingCancels: cancelState.remainingCancels,
        onConfirm: () async {
          try {
            await ref.read(cancelQueueProvider).call(activeQueue.id);
            await ref.read(cancelProvider.notifier).cancelQueue(activeQueue.id);

            if (mounted) {
              ref.read(queueListStateProvider.notifier).refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(child: Text('Antrian berhasil dibatalkan')),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString().replaceFirst('Exception: ', '')),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final turnState = ref.watch(turnNotificationProvider);
    final activeQueue = _findActiveQueue();

    if (turnState.isCalled) {
      return CalledDialog(
        customerName: turnState.customerName ?? 'Pelanggan',
        barberName: turnState.barberName,
        queueNumber: turnState.queueNumber ?? 0,
        onDismiss: () {
          ref.read(turnNotificationProvider.notifier).dismiss();
        },
      );
    }

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
      body: activeQueue != null
          ? _buildActiveQueueView(activeQueue)
          : _buildJoinQueueView(),
    );
  }

  Widget _buildJoinQueueView() {
    return Column(
      children: [
        Padding(
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
          const Expanded(
            child: RealtimeQueueList(),
          ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveQueueView(QueueEntity activeQueue) {
    final statusText = _statusDisplayText(activeQueue.status);
    final positionText = '#${activeQueue.position}';

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
                      child: Center(
                        child: Text(
                          '#${activeQueue.queueNumber}',
                          style: const TextStyle(
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
                            activeQueue.serviceName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (activeQueue.barberId != null)
                            Text(
                              'Barber: ${activeQueue.barberId}',
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
                      value: statusText,
                    ),
                    _StatusInfo(
                      icon: Icons.timer,
                      label: 'Estimasi',
                      value: '${_estimateMinutes(activeQueue)} menit',
                    ),
                    _StatusInfo(
                      icon: Icons.format_list_numbered,
                      label: 'Posisi',
                      value: positionText,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showQueuePosition(activeQueue),
                        icon: const Icon(Icons.visibility),
                        label: const Text('Lihat Antrian'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final cancelState = ref.watch(cancelProvider);
                          final canCancel = cancelState.canCancel;

                          return ElevatedButton.icon(
                            onPressed: canCancel ? () => _onCancelQueue(activeQueue) : null,
                            icon: const Icon(Icons.cancel),
                            label: Text(canCancel ? 'Batalkan' : 'Tidak Bisa'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canCancel ? AppColors.error : AppColors.textSecondaryLight,
                              foregroundColor: Colors.white,
                            ),
                          );
                        },
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

  void _showQueuePosition(QueueEntity activeQueue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Posisi Anda: #${activeQueue.queueNumber}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _statusDisplayText(String status) {
    switch (status) {
      case 'waiting':
        return 'Menunggu';
      case 'called':
        return 'Dipanggil';
      case 'in_progress':
        return 'Dalam Proses';
      default:
        return status;
    }
  }

  int _estimateMinutes(QueueEntity queue) {
    final position = queue.position;
    if (position <= 1) return 5;
    return position * 15;
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/theme/app_colors.dart';
import 'package:barberku_app/features/history/presentation/providers/history_providers.dart';
import 'package:barberku_app/features/history/data/models/history_model.dart';
import 'package:barberku_app/features/history/presentation/widgets/rating_dialog.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final Set<String> _recentlyRated = {};

  static const _customerId = 'test-customer-001';

  void _onRate(HistoryModel item) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const RatingDialog(),
    );

    if (result != null && mounted) {
      final rating = result['rating'] as int;
      final comment = result['comment'] as String;

      try {
        await ref.read(rateServiceProvider).call(
          queueId: item.id,
          rating: rating,
          comment: comment,
        );

        setState(() => _recentlyRated.add(item.id));

        ref.invalidate(getHistoryProvider(_customerId));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Terima kasih atas rating Anda!'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(getHistoryProvider(_customerId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kunjungan'),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                error.toString().replaceFirst('Exception: ', ''),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(getHistoryProvider(_customerId)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (history) {
          if (history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.textSecondaryLight),
                  SizedBox(height: 16),
                  Text('Belum ada riwayat kunjungan'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final statusDisplay = _statusDisplayText(item.status);
              final isRated = _recentlyRated.contains(item.id);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(item.createdAt),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item.status).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusDisplay,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(item.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(_formatTime(item.createdAt), style: const TextStyle(color: AppColors.textSecondaryLight)),
                          const SizedBox(width: 16),
                          const Icon(Icons.content_cut, size: 16, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text(item.serviceName, style: const TextStyle(color: AppColors.textSecondaryLight)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 4),
                          Text('Pelanggan: ${item.customerName}', style: const TextStyle(color: AppColors.textSecondaryLight)),
                        ],
                      ),
                      if (item.status == 'completed') ...[
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isRated ? 'Rating telah dikirim' : 'Belum memberi rating',
                              style: TextStyle(
                                color: isRated ? AppColors.success : AppColors.textSecondaryLight,
                                fontWeight: isRated ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (!isRated)
                              TextButton.icon(
                                onPressed: () => _onRate(item),
                                icon: const Icon(Icons.star_border, color: AppColors.accent),
                                label: const Text(
                                  'Beri Rating',
                                  style: TextStyle(color: AppColors.accent),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _statusDisplayText(String status) {
    switch (status) {
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'canceled':
        return AppColors.error;
      case 'skipped':
        return AppColors.warning;
      default:
        return AppColors.textSecondaryLight;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

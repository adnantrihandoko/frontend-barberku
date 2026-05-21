import 'package:flutter/material.dart';
import 'package:barberku_app/core/theme/app_colors.dart';
import 'package:barberku_app/features/history/presentation/widgets/rating_dialog.dart';

class HistoryItem {
  final String id;
  final String date;
  final String time;
  final String service;
  final String barber;
  final String status;
  final int? rating;

  const HistoryItem({
    required this.id,
    required this.date,
    required this.time,
    required this.service,
    required this.barber,
    required this.status,
    this.rating,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<HistoryItem> _history = [
    const HistoryItem(
      id: '1',
      date: '20 Mei 2026',
      time: '14:30',
      service: 'Potong Rambut',
      barber: 'Andi',
      status: 'Selesai',
      rating: 5,
    ),
    const HistoryItem(
      id: '2',
      date: '18 Mei 2026',
      time: '10:00',
      service: 'Cuci & Potong',
      barber: 'Budi',
      status: 'Selesai',
      rating: null,
    ),
    const HistoryItem(
      id: '3',
      date: '15 Mei 2026',
      time: '16:45',
      service: 'Potong Jenggot',
      barber: 'Candra',
      status: 'Dibatalkan',
      rating: null,
    ),
  ];

  void _onRate(HistoryItem item) async {
    final rating = await showDialog<int>(
      context: context,
      builder: (context) => const RatingDialog(),
    );

    if (rating != null) {
      setState(() {
        final index = _history.indexWhere((h) => h.id == item.id);
        if (index != -1) {
          _history[index] = HistoryItem(
            id: item.id,
            date: item.date,
            time: item.time,
            service: item.service,
            barber: item.barber,
            status: item.status,
            rating: rating,
          );
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terima kasih atas rating Anda!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kunjungan'),
      ),
      body: _history.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.textSecondaryLight),
                  SizedBox(height: 16),
                  Text('Belum ada riwayat kunjungan'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
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
                              item.date,
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
                                item.status,
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
                            Text(item.time, style: const TextStyle(color: AppColors.textSecondaryLight)),
                            const SizedBox(width: 16),
                            const Icon(Icons.content_cut, size: 16, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 4),
                            Text(item.service, style: const TextStyle(color: AppColors.textSecondaryLight)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 16, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 4),
                            Text('Barber: ${item.barber}', style: const TextStyle(color: AppColors.textSecondaryLight)),
                          ],
                        ),
                        if (item.status == 'Selesai') ...[
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.rating != null ? 'Rating Anda: ${item.rating}/5' : 'Belum memberi rating',
                                style: TextStyle(
                                  color: item.rating != null ? AppColors.accent : AppColors.textSecondaryLight,
                                  fontWeight: item.rating != null ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (item.rating == null)
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
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Selesai':
        return AppColors.success;
      case 'Dibatalkan':
        return AppColors.error;
      case 'Dilewati':
        return AppColors.warning;
      default:
        return AppColors.textSecondaryLight;
    }
  }
}

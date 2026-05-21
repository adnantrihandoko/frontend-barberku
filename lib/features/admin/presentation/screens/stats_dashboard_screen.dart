import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsDashboardScreen extends StatefulWidget {
  const StatsDashboardScreen({super.key});

  @override
  State<StatsDashboardScreen> createState() => _StatsDashboardScreenState();
}

class _StatsDashboardScreenState extends State<StatsDashboardScreen> {
  DateTime _selectedDate = DateTime.now();

  final Map<String, dynamic> _stats = {
    'total_served': 12,
    'total_canceled': 2,
    'avg_wait_time_min': 15.5,
    'avg_service_time_min': 25.0,
    'total_revenue': 360000.0,
  };

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Harian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
            tooltip: 'Pilih Tanggal',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                dateFormat.format(_selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _StatCard(
                  title: 'Total Dilayani',
                  value: _stats['total_served'].toString(),
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
                _StatCard(
                  title: 'Dibatalkan',
                  value: _stats['total_canceled'].toString(),
                  icon: Icons.cancel_outlined,
                  color: Colors.red,
                ),
                _StatCard(
                  title: 'Rata-rata Tunggu',
                  value: '${_stats['avg_wait_time_min']} mnt',
                  icon: Icons.hourglass_empty,
                  color: Colors.orange,
                ),
                _StatCard(
                  title: 'Rata-rata Layanan',
                  value: '${_stats['avg_service_time_min']} mnt',
                  icon: Icons.cut,
                  color: Colors.blue,
                ),
                _StatCard(
                  title: 'Total Pendapatan',
                  value: NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(_stats['total_revenue']),
                  icon: Icons.attach_money,
                  color: Colors.purple,
                  crossAxisCellCount: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int crossAxisCellCount;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.crossAxisCellCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

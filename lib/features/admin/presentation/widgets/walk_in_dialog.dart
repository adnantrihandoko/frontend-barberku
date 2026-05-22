import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/theme/app_colors.dart';
import 'package:barberku_app/features/admin/presentation/providers/admin_providers.dart';
import 'package:barberku_app/features/queue/presentation/providers/queue_provider.dart';

class WalkInDialog extends ConsumerStatefulWidget {
  const WalkInDialog({super.key});

  @override
  ConsumerState<WalkInDialog> createState() => _WalkInDialogState();
}

class _WalkInDialogState extends ConsumerState<WalkInDialog> {
  final _nameController = TextEditingController();
  String? _selectedServiceId;
  String? _selectedServiceName;
  String? _selectedBarberId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama wajib diisi'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    if (_selectedServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layanan wajib dipilih'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(addWalkInProvider).call(
        customerName: _nameController.text.trim(),
        serviceId: _selectedServiceId!,
        serviceName: _selectedServiceName ?? '',
        barberId: _selectedBarberId,
      );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Antrian walk-in untuk ${_nameController.text} berhasil ditambahkan'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e'), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);
    final barbersAsync = ref.watch(barbersProvider);

    return AlertDialog(
      title: const Text('Tambah Antrian Walk-In'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Pelanggan',
                hintText: 'Masukkan nama pelanggan',
                prefixIcon: Icon(Icons.person),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            servicesAsync.when(
              data: (services) => DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Layanan',
                  prefixIcon: Icon(Icons.content_cut),
                ),
                items: services.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedServiceId = value;
                    _selectedServiceName = services.firstWhere((s) => s.id == value).name;
                  });
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Gagal memuat: $e'),
            ),
            const SizedBox(height: 16),
            barbersAsync.when(
              data: (barbers) => DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Barber (Opsional)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Tidak Pilih')),
                  ...barbers.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))),
                ],
                onChanged: (value) {
                  setState(() => _selectedBarberId = value);
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Gagal memuat: $e'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _onSubmit,
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Tambah'),
        ),
      ],
    );
  }
}

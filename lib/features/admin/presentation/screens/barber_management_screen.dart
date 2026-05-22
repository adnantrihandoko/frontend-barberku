import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/theme/app_colors.dart';
import 'package:barberku_app/features/admin/presentation/providers/admin_providers.dart';
import 'package:barberku_app/features/admin/data/models/barber_model.dart';

class BarberManagementScreen extends ConsumerStatefulWidget {
  const BarberManagementScreen({super.key});

  @override
  ConsumerState<BarberManagementScreen> createState() => _BarberManagementScreenState();
}

class _BarberManagementScreenState extends ConsumerState<BarberManagementScreen> {
  void _onAddBarber() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const BarberDialog(),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barber berhasil ditambahkan'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onEditBarber(BarberModel barber) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => BarberDialog(barber: barber),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barber berhasil diperbarui'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onDeleteBarber(BarberModel barber) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Barber'),
        content: Text('Yakin ingin menghapus "${barber.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(deleteBarberProvider).call(barber.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Barber "${barber.name}" berhasil dihapus'),
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
    final barbersAsync = ref.watch(barbersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Barber'),
      ),
      body: barbersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
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
                onPressed: () => ref.invalidate(barbersProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (barbers) {
          if (barbers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 64, color: AppColors.textSecondaryLight),
                  SizedBox(height: 16),
                  Text('Belum ada barber'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: barbers.length,
            itemBuilder: (context, index) {
              final barber = barbers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: barber.isActive
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.textSecondaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      color: barber.isActive ? AppColors.primary : AppColors.textSecondaryLight,
                    ),
                  ),
                  title: Text(
                    barber.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: barber.isActive ? null : AppColors.textSecondaryLight,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(barber.specialty),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: barber.isActive
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          barber.isActive ? 'Aktif' : 'Nonaktif',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: barber.isActive ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _onEditBarber(barber),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                        onPressed: () => _onDeleteBarber(barber),
                        tooltip: 'Hapus',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddBarber,
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah Barber'),
      ),
    );
  }
}

class BarberDialog extends ConsumerStatefulWidget {
  final BarberModel? barber;

  const BarberDialog({super.key, this.barber});

  @override
  ConsumerState<BarberDialog> createState() => _BarberDialogState();
}

class _BarberDialogState extends ConsumerState<BarberDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late bool _isActive;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.barber?.name ?? '');
    _specialtyController = TextEditingController(text: widget.barber?.specialty ?? '');
    _isActive = widget.barber?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      if (widget.barber == null) {
        await ref.read(createBarberProvider).call(
          name: _nameController.text.trim(),
          specialty: _specialtyController.text.trim(),
        );
      } else {
        await ref.read(updateBarberProvider).call(
          id: widget.barber!.id,
          name: _nameController.text.trim(),
          specialty: _specialtyController.text.trim(),
          isActive: _isActive,
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.barber != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Barber' : 'Tambah Barber'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barber',
                  hintText: 'Contoh: Andi',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama barber wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(
                  labelText: 'Spesialisasi',
                  hintText: 'Contoh: Senior Barber',
                  prefixIcon: Icon(Icons.content_cut),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Aktif'),
                subtitle: const Text('Barber tersedia untuk pelanggan'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _onSubmit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEdit ? 'Simpan' : 'Tambah'),
        ),
      ],
    );
  }
}

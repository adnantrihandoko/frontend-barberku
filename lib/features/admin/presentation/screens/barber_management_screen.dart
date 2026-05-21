import 'package:flutter/material.dart';
import 'package:barberku_app/core/theme/app_colors.dart';

class BarberModel {
  final String id;
  final String name;
  final String specialty;
  final bool isActive;

  const BarberModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.isActive = true,
  });
}

class BarberManagementScreen extends StatefulWidget {
  const BarberManagementScreen({super.key});

  @override
  State<BarberManagementScreen> createState() => _BarberManagementScreenState();
}

class _BarberManagementScreenState extends State<BarberManagementScreen> {
  final List<BarberModel> _barbers = [
    const BarberModel(
      id: '1',
      name: 'Andi',
      specialty: 'Senior Barber',
    ),
    const BarberModel(
      id: '2',
      name: 'Budi',
      specialty: 'Hair Stylist',
    ),
    const BarberModel(
      id: '3',
      name: 'Candra',
      specialty: 'Junior Barber',
    ),
  ];

  void _onAddBarber() async {
    final result = await showDialog<BarberModel>(
      context: context,
      builder: (context) => const BarberDialog(),
    );

    if (result != null) {
      setState(() {
        _barbers.add(result);
      });
    }
  }

  void _onEditBarber(BarberModel barber) async {
    final result = await showDialog<BarberModel>(
      context: context,
      builder: (context) => BarberDialog(barber: barber),
    );

    if (result != null) {
      setState(() {
        final index = _barbers.indexWhere((b) => b.id == result.id);
        if (index != -1) {
          _barbers[index] = result;
        }
      });
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
      setState(() {
        _barbers.removeWhere((b) => b.id == barber.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Barber "${barber.name}" berhasil dihapus'),
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
        title: const Text('Manajemen Barber'),
      ),
      body: _barbers.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 64, color: AppColors.textSecondaryLight),
                  SizedBox(height: 16),
                  Text('Belum ada barber'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _barbers.length,
              itemBuilder: (context, index) {
                final barber = _barbers[index];
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
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddBarber,
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah Barber'),
      ),
    );
  }
}

class BarberDialog extends StatefulWidget {
  final BarberModel? barber;

  const BarberDialog({super.key, this.barber});

  @override
  State<BarberDialog> createState() => _BarberDialogState();
}

class _BarberDialogState extends State<BarberDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late bool _isActive;

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

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final barber = BarberModel(
        id: widget.barber?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        specialty: _specialtyController.text.trim(),
        isActive: _isActive,
      );

      Navigator.of(context).pop(barber);
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _onSubmit,
          child: Text(isEdit ? 'Simpan' : 'Tambah'),
        ),
      ],
    );
  }
}

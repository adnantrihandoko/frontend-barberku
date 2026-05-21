import 'package:flutter/material.dart';
import 'package:barberku_app/core/theme/app_colors.dart';

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final bool isActive;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    this.isActive = true,
  });
}

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  final List<ServiceModel> _services = [
    const ServiceModel(
      id: '1',
      name: 'Potong Rambut',
      description: 'Potong rambut standar dengan gaya modern',
      price: 35000,
      durationMinutes: 30,
    ),
    const ServiceModel(
      id: '2',
      name: 'Cuci & Potong',
      description: 'Cuci rambut terlebih dahulu, lalu potong',
      price: 50000,
      durationMinutes: 45,
    ),
    const ServiceModel(
      id: '3',
      name: 'Potong Jenggot',
      description: 'Merapikan dan membentuk jenggot',
      price: 25000,
      durationMinutes: 20,
    ),
    const ServiceModel(
      id: '4',
      name: 'Pewarnaan',
      description: 'Mewarnai rambut dengan pilihan warna',
      price: 150000,
      durationMinutes: 90,
    ),
  ];

  void _onAddService() async {
    final result = await showDialog<ServiceModel>(
      context: context,
      builder: (context) => const ServiceDialog(),
    );

    if (result != null) {
      setState(() {
        _services.add(result);
      });
    }
  }

  void _onEditService(ServiceModel service) async {
    final result = await showDialog<ServiceModel>(
      context: context,
      builder: (context) => ServiceDialog(service: service),
    );

    if (result != null) {
      setState(() {
        final index = _services.indexWhere((s) => s.id == result.id);
        if (index != -1) {
          _services[index] = result;
        }
      });
    }
  }

  void _onDeleteService(ServiceModel service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Layanan'),
        content: Text('Yakin ingin menghapus "${service.name}"?'),
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
        _services.removeWhere((s) => s.id == service.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Layanan "${service.name}" berhasil dihapus'),
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
        title: const Text('Manajemen Layanan'),
      ),
      body: _services.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.content_cut, size: 64, color: AppColors.textSecondaryLight),
                  SizedBox(height: 16),
                  Text('Belum ada layanan'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: service.isActive
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.textSecondaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.content_cut,
                        color: service.isActive ? AppColors.primary : AppColors.textSecondaryLight,
                      ),
                    ),
                    title: Text(
                      service.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: service.isActive ? null : AppColors.textSecondaryLight,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(service.description),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Rp${service.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${service.durationMinutes} menit',
                              style: const TextStyle(
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _onEditService(service),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: AppColors.error,
                          onPressed: () => _onDeleteService(service),
                          tooltip: 'Hapus',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddService,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Layanan'),
      ),
    );
  }
}

class ServiceDialog extends StatefulWidget {
  final ServiceModel? service;

  const ServiceDialog({super.key, this.service});

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _descriptionController = TextEditingController(text: widget.service?.description ?? '');
    _priceController = TextEditingController(
      text: widget.service?.price.toStringAsFixed(0) ?? '',
    );
    _durationController = TextEditingController(
      text: widget.service?.durationMinutes.toString() ?? '',
    );
    _isActive = widget.service?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final service = ServiceModel(
        id: widget.service?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        durationMinutes: int.parse(_durationController.text),
        isActive: _isActive,
      );

      Navigator.of(context).pop(service);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.service != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Layanan' : 'Tambah Layanan'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Layanan',
                  hintText: 'Contoh: Potong Rambut',
                  prefixIcon: Icon(Icons.content_cut),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama layanan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Deskripsi singkat layanan',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Harga (Rp)',
                        hintText: '35000',
                        prefixIcon: Icon(Icons.money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Harga wajib diisi';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Harga tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Durasi (menit)',
                        hintText: '30',
                        prefixIcon: Icon(Icons.timer),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Durasi wajib diisi';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Durasi tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Aktif'),
                subtitle: const Text('Layanan tersedia untuk pelanggan'),
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

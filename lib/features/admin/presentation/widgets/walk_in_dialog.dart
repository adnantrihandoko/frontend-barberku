import 'package:flutter/material.dart';
import 'package:barberku_app/core/theme/app_colors.dart';

class WalkInDialog extends StatefulWidget {
  const WalkInDialog({super.key});

  @override
  State<WalkInDialog> createState() => _WalkInDialogState();
}

class _WalkInDialogState extends State<WalkInDialog> {
  final _nameController = TextEditingController();
  String? _selectedService;
  String? _selectedBarber;

  final _services = ['Potong Rambut', 'Cuci & Potong', 'Potong Jenggot', 'Pewarnaan'];
  final _barbers = ['Andi', 'Budi', 'Candra', 'Tidak Pilih'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_nameController.text.trim().isEmpty || _selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama dan layanan wajib diisi'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Antrian walk-in untuk ${_nameController.text} berhasil ditambahkan'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            DropdownButtonFormField<String>(
              initialValue: _selectedService,
              decoration: const InputDecoration(
                labelText: 'Layanan',
                prefixIcon: Icon(Icons.content_cut),
              ),
              items: _services.map((service) {
                return DropdownMenuItem(value: service, child: Text(service));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedService = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedBarber,
              decoration: const InputDecoration(
                labelText: 'Barber (Opsional)',
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: _barbers.map((barber) {
                return DropdownMenuItem(value: barber, child: Text(barber));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBarber = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _onSubmit,
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}

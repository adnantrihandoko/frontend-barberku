import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barberku_app/core/theme/app_colors.dart';
import 'package:barberku_app/features/customer/presentation/models/customer_models.dart';

class JoinQueueBottomSheet extends StatefulWidget {
  const JoinQueueBottomSheet({super.key});

  @override
  State<JoinQueueBottomSheet> createState() => _JoinQueueBottomSheetState();
}

class _JoinQueueBottomSheetState extends State<JoinQueueBottomSheet> {
  final _nameController = TextEditingController();
  ServiceModel? _selectedService;
  BarberModel? _selectedBarber;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Pelanggan';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onJoinQueue() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama wajib diisi'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih layanan terlebih dahulu'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop({
        'customerName': _nameController.text.trim(),
        'service': _selectedService,
        'barber': _selectedBarber,
        'queueNumber': 5,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ambil Antrian',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih layanan dan barber untuk bergabung ke antrian',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Anda',
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih Layanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...dummyServices.map((service) => _ServiceTile(
                    service: service,
                    isSelected: _selectedService?.id == service.id,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedService = service;
                      });
                    },
                  )),
              const SizedBox(height: 16),
              const Text(
                'Pilih Barber (Opsional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _BarberChip(
                    barber: null,
                    isSelected: _selectedBarber == null,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedBarber = null;
                      });
                    },
                  ),
                  ...dummyBarbers.map((barber) => _BarberChip(
                        barber: barber,
                        isSelected: _selectedBarber?.id == barber.id,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _selectedBarber = barber;
                          });
                        },
                      )),
                ],
              ),
              const SizedBox(height: 24),
              if (_selectedService != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedService!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Estimasi: ${_selectedService!.durationMinutes} menit',
                            style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Rp${_selectedService!.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onJoinQueue,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Ambil Antrian',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServiceModel service;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  Text(
                    '${service.durationMinutes} menit • Rp${service.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarberChip extends StatelessWidget {
  final BarberModel? barber;
  final bool isSelected;
  final VoidCallback onTap;

  const _BarberChip({
    this.barber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          barber?.name ?? 'Bebas',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimaryLight,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

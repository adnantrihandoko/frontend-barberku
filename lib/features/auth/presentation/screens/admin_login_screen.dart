import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barberku_app/core/core.dart';
import 'package:barberku_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:barberku_app/features/auth/presentation/widgets/pin_input_field.dart';
import 'package:barberku_app/features/auth/presentation/widgets/numeric_keypad.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController();
  String _pin = '';
  bool _isEmailSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onPinSubmitted() async {
    if (_pin.length < 4) return;

    HapticFeedback.mediumImpact();

    await ref.read(authStateProvider.notifier).loginWithPin(
          email: _emailController.text.trim(),
          pin: _pin,
        );

    final state = ref.read(authStateProvider);

    if (state.isAuthenticated) {
      if (mounted) {
        context.go(AppRoutes.adminDashboard);
      }
    } else if (state.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _pin = '';
        });
      }
    }
  }

  void _onDigitPressed(String digit) {
    if (_pin.length >= 6) return;
    
    setState(() {
      _pin += digit;
    });
    
    HapticFeedback.lightImpact();

    if (_pin.length >= 4) {
      _onPinSubmitted();
    }
  }

  void _onDeletePressed() {
    if (_pin.isEmpty) return;
    
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
    });
    
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Admin Login',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan email dan PIN untuk mengakses dashboard',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                  const SizedBox(height: 32),
                  if (!_isEmailSubmitted) ...[
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'admin@barberku.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      onSubmitted: (_) {
                        if (_emailController.text.trim().isNotEmpty) {
                          setState(() {
                            _isEmailSubmitted = true;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _emailController.text.trim().isNotEmpty
                            ? () {
                                setState(() {
                                  _isEmailSubmitted = true;
                                });
                              }
                            : null,
                        child: const Text('Lanjutkan'),
                      ),
                    ),
                  ] else ...[
                    Text(
                      _emailController.text,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    PinInputField(pin: _pin),
                    const SizedBox(height: 32),
                    NumericKeypad(
                      onDigitPressed: _onDigitPressed,
                      onDeletePressed: _onDeletePressed,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEmailSubmitted = false;
                          _pin = '';
                        });
                      },
                      child: const Text('Ganti Email'),
                    ),
                  ],
                  if (authState.isLoading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

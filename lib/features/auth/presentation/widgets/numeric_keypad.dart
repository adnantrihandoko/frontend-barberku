import 'package:flutter/material.dart';
import 'package:barberku_app/core/theme/app_colors.dart';

class NumericKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onDeletePressed;
  
  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _KeypadButton(label: '1', onPressed: () => onDigitPressed('1')),
        _KeypadButton(label: '2', onPressed: () => onDigitPressed('2')),
        _KeypadButton(label: '3', onPressed: () => onDigitPressed('3')),
        _KeypadButton(label: '4', onPressed: () => onDigitPressed('4')),
        _KeypadButton(label: '5', onPressed: () => onDigitPressed('5')),
        _KeypadButton(label: '6', onPressed: () => onDigitPressed('6')),
        _KeypadButton(label: '7', onPressed: () => onDigitPressed('7')),
        _KeypadButton(label: '8', onPressed: () => onDigitPressed('8')),
        _KeypadButton(label: '9', onPressed: () => onDigitPressed('9')),
        const SizedBox.shrink(),
        _KeypadButton(label: '0', onPressed: () => onDigitPressed('0')),
        _DeleteButton(onPressed: onDeletePressed),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const _KeypadButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: const Icon(
          Icons.backspace_outlined,
          color: AppColors.error,
          size: 28,
        ),
      ),
    );
  }
}

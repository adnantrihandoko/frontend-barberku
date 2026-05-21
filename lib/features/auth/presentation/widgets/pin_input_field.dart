import 'package:flutter/material.dart';
import 'package:barberku_app/core/theme/app_colors.dart';

class PinInputField extends StatelessWidget {
  final String pin;
  final int maxLength;
  
  const PinInputField({
    super.key,
    required this.pin,
    this.maxLength = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        final isFilled = index < pin.length;
        final isCurrent = index == pin.length;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 48,
          height: 56,
          decoration: BoxDecoration(
            color: isFilled ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            border: Border.all(
              color: isCurrent
                  ? AppColors.primary
                  : isFilled
                      ? AppColors.primary
                      : AppColors.textSecondaryLight.withValues(alpha: 0.3),
              width: isCurrent ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isFilled
                  ? Icon(
                      Icons.circle,
                      key: ValueKey(index),
                      size: 16,
                      color: AppColors.primary,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonStyle { primary, ghost, accent }

/// Стилізована кнопка, що повторюється на кількох екранах
/// (авторизація, реєстрація, профіль, dashboard).
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool fullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = switch (style) {
      AppButtonStyle.primary => AppColors.ink,
      AppButtonStyle.accent => AppColors.accent,
      AppButtonStyle.ghost => Colors.transparent,
    };
    final Color fg = switch (style) {
      AppButtonStyle.ghost => AppColors.ink,
      _ => Colors.white,
    };
    final Color borderColor = switch (style) {
      AppButtonStyle.ghost => AppColors.line,
      AppButtonStyle.accent => AppColors.accent,
      AppButtonStyle.primary => AppColors.ink,
    };

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
        ),
        child: child,
      ),
    );
  }
}
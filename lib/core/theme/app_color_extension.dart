import 'package:flutter/material.dart';
import 'package:trading_app/core/theme/app_colors.dart';

/// [AppColorExtension]
/// A Flutter ThemeExtension holding all theme-dependent colors (text,
/// surface, border, primary) PLUS the theme-independent semantic ones
/// (success/error) for convenience, so a widget only ever needs ONE
@immutable
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color primary;
  final Color success;
  final Color successBg;
  final Color error;
  final Color errorBg;
  final Color neutral;

  const AppColorExtension({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.primary,
    required this.success,
    required this.successBg,
    required this.error,
    required this.errorBg,
    required this.neutral,
  });

  static const light = AppColorExtension(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    surfaceVariant: AppColors.lightSurfaceVariant,
    border: AppColors.lightBorder,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textDisabled: AppColors.lightTextDisabled,
    primary: AppColors.primary,
    success: AppColors.success,
    successBg: AppColors.successBg,
    error: AppColors.error,
    errorBg: AppColors.errorBg,
    neutral: AppColors.neutral,
  );

  static const dark = AppColorExtension(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceVariant: AppColors.darkSurfaceVariant,
    border: AppColors.darkBorder,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textDisabled: AppColors.darkTextDisabled,
    primary: AppColors.primaryLight,
    success: AppColors.success,
    successBg: AppColors.successBg,
    error: AppColors.error,
    errorBg: AppColors.errorBg,
    neutral: AppColors.neutral,
  );

  @override
  AppColorExtension copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? primary,
    Color? success,
    Color? successBg,
    Color? error,
    Color? errorBg,
    Color? neutral,
  }) {
    return AppColorExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      primary: primary ?? this.primary,
      success: success ?? this.success,
      successBg: successBg ?? this.successBg,
      error: error ?? this.error,
      errorBg: errorBg ?? this.errorBg,
      neutral: neutral ?? this.neutral,
    );
  }

  @override
  AppColorExtension lerp(ThemeExtension<AppColorExtension>? other, double t) {
    if (other is! AppColorExtension) return this;
    return AppColorExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
    );
  }
}

/// Ergonomic shortcut: `context.appColors` instead of
/// `Theme.of(context).extension<AppColorExtension>()!`.
extension AppColorExtensionContextX on BuildContext {
  AppColorExtension get appColors => Theme.of(this).extension<AppColorExtension>()!;
}
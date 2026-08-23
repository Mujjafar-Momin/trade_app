import 'package:flutter/material.dart';

/// [AppTextStyles]
/// Central text style catalog. Naming convention: `{weight}{size}`.
/// e.g. `AppTextStyles.medium14` = FontWeight.w500 at 14px.
///
/// These styles intentionally carry NO color — color is applied at the
/// point of use (`AppTextStyles.medium14.copyWith(color: ...)`) or via
/// AppTheme's TextTheme, which already applies the correct light/dark
/// text color for you when you use a Theme.of(context).textTheme role
/// instead of these directly.
///
/// Use these directly when you need a specific weight/size combo that
/// doesn't map cleanly to a Material text role (e.g. a price ticker cell,
/// a small badge) — use Theme.of(context).textTheme.* for everything else
/// so color/theme-switching stays automatic.
class AppTextStyles {
  AppTextStyles._();

  // --- Regular (w400) ---
  static const TextStyle regular12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle regular14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle regular16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle regular18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.4);

  // --- Medium (w500) ---
  static const TextStyle medium12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.4);
  static const TextStyle medium14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4);
  static const TextStyle medium16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4);
  static const TextStyle medium18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.4);

  // --- Semibold (w600) ---
  static const TextStyle semibold12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3);
  static const TextStyle semibold14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3);
  static const TextStyle semibold16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3);
  static const TextStyle semibold18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);

  // --- Bold (w700) ---
  static const TextStyle bold12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w700, height: 1.3);
  static const TextStyle bold14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 1.3);
  static const TextStyle bold16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.3);
  static const TextStyle bold18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.3);
}

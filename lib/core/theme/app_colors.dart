import 'package:flutter/material.dart';

/// [AppColors]
/// Central color palette for the app. Nothing in the UI should hardcode
/// a Color(0x...) value directly — always reference something from here
/// (or from context.appColors, once AppTheme wires these in), so a
/// palette change only ever needs to happen in one file.
class AppColors {
  AppColors._();

  // --- Brand (blue) ---
  static const Color primary = Color(0xFF2563EB); // blue-600
  static const Color primaryLight = Color(0xFF60A5FA); // blue-400
  static const Color primaryDark = Color(0xFF1D4ED8); // blue-700

  // --- Semantic trading colors (theme-independent) ---
  static const Color success = Color(0xFF16A34A); // green-600
  static const Color successBg = Color(0xFFDCFCE7); // green-100, flash bg
  static const Color error = Color(0xFFDC2626); // red-600
  static const Color errorBg = Color(0xFFFEE2E2); // red-100, flash bg
  static const Color neutral = Color(0xFF6B7280); // gray-500, zero change

  // --- Light theme surface/text colors ---
  static const Color lightBackground = Color(0xFFF9FAFB); // gray-50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6); // gray-100
  static const Color lightBorder = Color(0xFFE5E7EB); // gray-200
  static const Color lightTextPrimary = Color(0xFF111827); // gray-900
  static const Color lightTextSecondary = Color(0xFF6B7280); // gray-500
  static const Color lightTextDisabled = Color(0xFFD1D5DB); // gray-300

  // --- Dark theme surface/text colors ---
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111827); // gray-900
  static const Color darkSurfaceVariant = Color(0xFF1F2937); // gray-800
  static const Color darkBorder = Color(0xFF374151); // gray-700
  static const Color darkTextPrimary = Color(0xFFF9FAFB); // gray-50
  static const Color darkTextSecondary = Color(0xFF9CA3AF); // gray-400
  static const Color darkTextDisabled = Color(0xFF4B5563); // gray-600

  // --- Status colors ---
  static const Color warning = Color(0xFFD97706); // amber-600
  static const Color info = Color(0xFF2563EB); // reuse primary
}

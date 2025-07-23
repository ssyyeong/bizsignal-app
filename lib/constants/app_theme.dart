import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 앱의 테마 설정을 정의하는 클래스
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// 라이트 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primary100,
        onPrimaryContainer: AppColors.primary900,

        secondary: AppColors.primary,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.primary100,
        onSecondaryContainer: AppColors.primary900,

        tertiary: AppColors.primary,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.primary100,
        onTertiaryContainer: AppColors.primary900,

        error: AppColors.alertWarning,
        onError: AppColors.white,
        errorContainer: AppColors.alertWarning,
        onErrorContainer: AppColors.alertWarning,
        surface: AppColors.gray0,
        onSurface: AppColors.gray900,
        surfaceContainerHighest: AppColors.gray100,
        onSurfaceVariant: AppColors.gray700,

        outline: AppColors.gray200,
        outlineVariant: AppColors.gray100,

        shadow: AppColors.gray300,
        scrim: AppColors.gray400,
        inverseSurface: AppColors.gray900,
        onInverseSurface: AppColors.white,
        inversePrimary: AppColors.primary100,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.gray0,
        foregroundColor: AppColors.gray900,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: AppColors.gray0,
        titleTextStyle: TextStyle(
          color: AppColors.gray900,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.gray0,
        elevation: 2,
        shadowColor: AppColors.gray300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.gray300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray0,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.alertWarning),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.alertWarning, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: const TextStyle(color: AppColors.gray500),
      ),
    );
  }

  /// 다크 테마 (필요시 사용)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme for dark theme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primary900,
        onPrimaryContainer: AppColors.primary100,

        secondary: AppColors.primary,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.primary100,
        onSecondaryContainer: AppColors.primary900,

        tertiary: AppColors.primary,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.primary100,
        onTertiaryContainer: AppColors.primary900,

        error: AppColors.alertWarning,
        onError: AppColors.white,
        errorContainer: AppColors.alertWarning,
        onErrorContainer: AppColors.alertWarning,
        surface: AppColors.gray800,
        onSurface: AppColors.white,
        surfaceContainerHighest: AppColors.gray700,
        onSurfaceVariant: AppColors.gray300,

        outline: AppColors.gray600,
        outlineVariant: AppColors.gray700,

        shadow: AppColors.gray300,
        scrim: AppColors.gray400,
        inverseSurface: AppColors.white,
        onInverseSurface: AppColors.gray900,
        inversePrimary: AppColors.primary900,
      ),
    );
  }
}

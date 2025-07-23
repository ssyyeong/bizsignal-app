import 'package:flutter/material.dart';

/// 앱에서 사용하는 모든 색상값들을 정의하는 클래스
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary50 = Color(0xFFFFF1EA);
  static const Color primary100 = Color(0xFFFFE9DF);
  static const Color primary200 = Color(0xFFFFD5BA);
  static const Color primary300 = Color(0xFFFFA781);
  static const Color primary400 = Color(0xFFFF8652);
  static const Color primary500 = Color(0xFFFF6928); // Default
  static const Color primary600 = Color(0xFFE4E40A);
  static const Color primary700 = Color(0xFFCC3D00);
  static const Color primary800 = Color(0xFFA33100);
  static const Color primary900 = Color(0xFF762300);
  static const Color primary = primary500; // 앱 기본 primary

  // Alert Colors
  static const Color alertWarning = Color(0xFFFF5959); // 500*

  // Grayscale
  static const Color gray0 = Color(0xFFFFFFFF); // white
  static const Color gray50 = Color(0xFFF6F7F9);
  static const Color gray100 = Color(0xFFF0F2F5);
  static const Color gray200 = Color(0xFFE8ECEF); // border
  static const Color gray300 = Color(0xFFDEE1E6);
  static const Color gray400 = Color(0xFFD0D4DA);
  static const Color gray500 = Color(0xFFADB6BD);
  static const Color gray600 = Color(0xFF858E95);
  static const Color gray700 = Color(0xFF495056);
  static const Color gray800 = Color(0xFF353A40);
  static const Color gray900 = Color(0xFF22252A);
  static const Color gray1000 = Color(0xFF0C0D0D); // black

  static const Color white = gray0;
  static const Color black = gray1000;
  static const Color border = gray200;
}

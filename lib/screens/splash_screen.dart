import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/screens/auth/login_screen.dart';
import 'package:bizsignal_app/screens/main/main_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 로그인 상태 확인
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    // 2초 후 화면 전환
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (token != '') {
        // 로그인 상태라면 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // 로그인 상태가 아니라면 로그인 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SvgPicture.asset('assets/images/logo/logo_white.svg'),
      ),
    );
  }
}

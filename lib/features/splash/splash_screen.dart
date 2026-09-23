import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // المستخدم مسجل مسبقاً -> الانتقال للرئيسية مباشرة
        context.go(Routes.homePageScreen);
      } else {
        // المستخدم غير مسجل أو أول مرة -> الانتقال لصفحة تسجيل الدخول
        context.go(Routes.loginScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Image.asset(
          isDarkMode ? AppImages.logoDarkImg : AppImages.logoImg,
          fit: BoxFit.contain,
          width: 70.w,
          height: 30.h,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            AppImages.logoImg,
            fit: BoxFit.contain,
            width: 70.w,
            height: 30.h,
          ),
        ),
      ),
    );
  }
}

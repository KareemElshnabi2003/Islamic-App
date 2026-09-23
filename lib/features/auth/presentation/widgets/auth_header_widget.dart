import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDarkMode;

  const AuthHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.dividerColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // شعار التطبيق مع لمسة جمالية
        Container(
          width: 28.w,
          height: 14.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode 
                ? const Color(0xFF141A2E).withAlpha(180) 
                : Colors.white.withAlpha(200),
            boxShadow: [
              BoxShadow(
                color: accentColor.withAlpha(50),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: accentColor.withAlpha(120),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              isDarkMode ? AppImages.logoDarkImg : AppImages.logoImg,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                AppImages.logoImg,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.5.h),

        // العنوان الرئيسي
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.elMessiri(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode
                ? const Color(0xFFFACC1D)
                : const Color(0xFFB7935F),
          ),
        ),
        SizedBox(height: 1.h),

        // الوصف التوضيحي
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.elMessiri(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFF555555),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

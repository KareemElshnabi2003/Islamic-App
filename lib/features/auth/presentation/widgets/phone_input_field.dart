import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final Function(String)? onCountryChanged;
  final bool isDarkMode;
  final String? errorText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.selectedCountryCode = "+20",
    this.onCountryChanged,
    required this.isDarkMode,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.dividerColor;

    final cardBg = isDarkMode
        ? const Color(0xFF1B233D).withAlpha(220)
        : Colors.white.withAlpha(240);

    final textColor = isDarkMode
        ? Colors.white
        : const Color(0xFF242424);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الحاوية الرئيسية
        Container(
          height: 7.h,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText != null
                  ? Colors.red
                  : accentColor.withAlpha(120),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withAlpha(60)
                    : accentColor.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              // كود الدولة
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: accentColor.withAlpha(80),
                      width: 1.2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "🇪🇬",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      selectedCountryCode,
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),

              // حقل إدخال الرقم
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: textColor,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: InputDecoration(
                    hintText: "101 234 5678",
                    hintTextDirection: TextDirection.ltr,
                    hintStyle: GoogleFonts.cairo(
                      fontSize: 13.sp,
                      color: textColor.withAlpha(100),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.phone_android_rounded,
                      color: accentColor,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // رسالة الخطأ إن وُجدت
        if (errorText != null) ...[
          SizedBox(height: 0.8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              errorText!,
              style: GoogleFonts.elMessiri(
                color: Colors.redAccent,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

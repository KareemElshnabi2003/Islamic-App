import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:islamic_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:islamic_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:islamic_app/features/auth/presentation/widgets/auth_header_widget.dart';
import 'package:islamic_app/features/auth/presentation/widgets/phone_input_field.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final String _countryCode = "+20";
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtpPressed() {
    final rawNumber = _phoneController.text.trim();
    if (rawNumber.isEmpty) {
      setState(() {
        _errorMessage = "يرجى إدخال رقم الهاتف";
      });
      return;
    }

    // تنظيف الرقم وإزالة الصفر في البداية إن وُجد لتوحيد الصيغة الدولية
    String cleanNumber = rawNumber;
    if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }

    if (cleanNumber.length < 10) {
      setState(() {
        _errorMessage = "رقم الهاتف غير مكتمل، يرجى كتابة 10 أرقام على الأقل";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final fullPhoneNumber = "$_countryCode$cleanNumber";
    context.read<AuthCubit>().sendOtp(phoneNumber: fullPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final accentColor = theme.dividerColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthOtpSentSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تم إرسال رمز التحقق بنجاح",
                        style: GoogleFonts.elMessiri(color: Colors.white),
                      ),
                      backgroundColor: Colors.green.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  context.push(
                    Routes.verifyCodeScreen,
                    extra: {
                      'verificationId': state.verificationId,
                      'phoneNumber': state.phoneNumber,
                    },
                  );
                } else if (state is AuthSuccess) {
                  context.go(Routes.homePageScreen);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message,
                        style: GoogleFonts.elMessiri(color: Colors.white),
                      ),
                      backgroundColor: Colors.red.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthSendingOtpLoading;

                return Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // الهيدر واللوجو
                        AuthHeaderWidget(
                          title: "تسجيل الدخول",
                          subtitle: "أهلاً بك، سجّل برقم هاتفك للوصول لكافة ميزات التطبيق ومتابعة وردك اليومي",
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 4.h),

                        // كارت إدخال رقم الهاتف
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF141A2E).withAlpha(190)
                                : Colors.white.withAlpha(210),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: accentColor.withAlpha(60),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode
                                    ? Colors.black.withAlpha(80)
                                    : accentColor.withAlpha(25),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "رقم الهاتف المحمول",
                                style: GoogleFonts.elMessiri(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? const Color(0xFFFACC1D)
                                      : const Color(0xFFB7935F),
                                ),
                              ),
                              SizedBox(height: 1.2.h),

                              // حقل الهاتف
                              PhoneInputField(
                                controller: _phoneController,
                                selectedCountryCode: _countryCode,
                                isDarkMode: isDarkMode,
                                errorText: _errorMessage,
                              ),
                              SizedBox(height: 1.5.h),

                              // تلميح نصي
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 14.sp,
                                    color: isDarkMode
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF718096),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      "سنرسل إليك رمز تأكيد مكوّن من 6 أرقام عبر رسالة نصية قصيرة SMS للتأكد من هويتك.",
                                      style: GoogleFonts.elMessiri(
                                        fontSize: 11.5.sp,
                                        color: isDarkMode
                                            ? const Color(0xFF94A3B8)
                                            : const Color(0xFF718096),
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.h),

                              // زر الإرسال
                              AuthButton(
                                text: "إرسال كود التحقق",
                                icon: Icons.send_rounded,
                                isLoading: isLoading,
                                isDarkMode: isDarkMode,
                                onPressed: _onSendOtpPressed,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),

                        // تذييل جميل
                        Text(
                          "تطبيق إسلامي • رفيقك اليومي في الذكر والعبادة",
                          style: GoogleFonts.elMessiri(
                            fontSize: 12.sp,
                            color: isDarkMode
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

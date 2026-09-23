import 'dart:async';
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
import 'package:islamic_app/features/auth/presentation/widgets/otp_input_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyCodeScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  late String _currentVerificationId;
  String _enteredOtp = "";
  final GlobalKey<OtpInputWidgetState> _otpKey = GlobalKey<OtpInputWidgetState>();

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onVerifyPressed() {
    if (_enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "يرجى إدخال رمز التحقق كاملاً المكون من 6 أرقام",
            style: GoogleFonts.elMessiri(color: Colors.white),
          ),
          backgroundColor: Colors.orange.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    context.read<AuthCubit>().verifyOtp(
          verificationId: _currentVerificationId,
          smsCode: _enteredOtp,
        );
  }

  void _onResendPressed() {
    if (!_canResend) return;

    _otpKey.currentState?.clear();
    _enteredOtp = "";

    context.read<AuthCubit>().sendOtp(
          phoneNumber: widget.phoneNumber,
          isResend: true,
        );
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
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تم تأكيد الحساب وتسجيل الدخول بنجاح!",
                        style: GoogleFonts.elMessiri(color: Colors.white),
                      ),
                      backgroundColor: Colors.green.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  context.go(Routes.homePageScreen);
                } else if (state is AuthOtpSentSuccess) {
                  _currentVerificationId = state.verificationId;
                  _startCountdown();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تمت إعادة إرسال رمز التحقق بنجاح",
                        style: GoogleFonts.elMessiri(color: Colors.white),
                      ),
                      backgroundColor: Colors.green.shade700,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
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
                final isVerifying = state is AuthVerifyingOtpLoading;
                final isResending = state is AuthSendingOtpLoading;

                return Column(
                  children: [
                    // زر الرجوع
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: isDarkMode ? Colors.white : const Color(0xFF242424),
                              size: 20.sp,
                            ),
                            onPressed: () => context.pop(),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // الهيدر
                              AuthHeaderWidget(
                                title: "تأكيد رمز التحقق",
                                subtitle: "تم إرسال كود التأكيد في رسالة نصية قصيرة SMS إلى الرقم:",
                                isDarkMode: isDarkMode,
                              ),
                              SizedBox(height: 1.h),

                              // عرض الرقم مع زر التعديل
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                                decoration: BoxDecoration(
                                  color: accentColor.withAlpha(isDarkMode ? 30 : 25),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: accentColor.withAlpha(80),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.phoneNumber,
                                      style: GoogleFonts.cairo(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? const Color(0xFFFACC1D)
                                            : const Color(0xFFB7935F),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    InkWell(
                                      onTap: () => context.pop(),
                                      child: Icon(
                                        Icons.edit_note_rounded,
                                        color: accentColor,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4.h),

                              // كارت خانات الـ OTP
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.5.h),
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
                                  children: [
                                    // خانات الكود الستة
                                    OtpInputWidget(
                                      key: _otpKey,
                                      length: 6,
                                      isDarkMode: isDarkMode,
                                      onChanged: (code) {
                                        _enteredOtp = code;
                                      },
                                      onCompleted: (code) {
                                        _enteredOtp = code;
                                        _onVerifyPressed();
                                      },
                                    ),
                                    SizedBox(height: 3.5.h),

                                    // زر التحقق
                                    AuthButton(
                                      text: "تأكيد ومتابعة",
                                      icon: Icons.check_circle_outline_rounded,
                                      isLoading: isVerifying,
                                      isDarkMode: isDarkMode,
                                      onPressed: _onVerifyPressed,
                                    ),
                                    SizedBox(height: 2.5.h),

                                    // عداد إعادة الإرسال
                                    if (!_canResend) ...[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer_outlined,
                                            size: 16.sp,
                                            color: isDarkMode
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF718096),
                                          ),
                                          SizedBox(width: 1.5.w),
                                          Text(
                                            "إعادة إرسال الكود خلال: 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                                            style: GoogleFonts.cairo(
                                              fontSize: 13.sp,
                                              color: isDarkMode
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF718096),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ] else ...[
                                      TextButton.icon(
                                        onPressed: isResending ? null : _onResendPressed,
                                        icon: isResending
                                            ? SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                                                ),
                                              )
                                            : Icon(
                                                Icons.replay_rounded,
                                                color: isDarkMode
                                                    ? const Color(0xFFFACC1D)
                                                    : const Color(0xFFB7935F),
                                                size: 18.sp,
                                              ),
                                        label: Text(
                                          "إعادة إرسال رمز التحقق",
                                          style: GoogleFonts.elMessiri(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                                ? const Color(0xFFFACC1D)
                                                : const Color(0xFFB7935F),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/features/drawer/compus/presentation/cubit/compus_cubit.dart';
import 'package:islamic_app/features/drawer/compus/presentation/cubit/compus_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:islamic_app/core/di/service_locator.dart';

class CompusScreen extends StatelessWidget {
  const CompusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (context) => sl<QiblaCubit>()..getQiblaDirection(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Container(
          height: 100.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              AppBarDrawerScreensWidget(back: true),
              Expanded(
                child: BlocBuilder<QiblaCubit, QiblaState>(
                  builder: (context, state) {
                    if (state is QiblaLoading || state is QiblaInitial) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              'جاري تحديد الموقع وحساب القبلة...',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14.sp,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is QiblaPermissionDenied) {
                      return _buildPermissionSheet(context);
                    } else if (state is QiblaSuccess) {
                      return _CompassWidget(qiblaBearing: state.qiblaBearing);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionSheet(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.location_off_outlined, size: 54, color: Colors.orange),
            const SizedBox(height: 14),
            const Text(
              'نحتاج تفعيل خدمة الـ GPS وصلاحية الموقع لتحديد اتجاه القبلة بدقة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text(
                'المحاولة مرة أخرى',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              onPressed: () {
                context.read<QiblaCubit>().getQiblaDirection();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassWidget extends StatefulWidget {
  final double qiblaBearing;
  const _CompassWidget({required this.qiblaBearing});

  @override
  State<_CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<_CompassWidget> {
  bool _isAligned = false;
  CompassEvent? _lastEvent;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _noSensorAvailable = false;
  Timer? _sensorTimeoutTimer;

  @override
  void initState() {
    super.initState();
    _startCompassListening();
  }

  void _startCompassListening() {
    _sensorTimeoutTimer?.cancel();
    _compassSubscription?.cancel();

    final stream = FlutterCompass.events;
    if (stream == null) {
      setState(() {
        _noSensorAvailable = true;
      });
      return;
    }

    // إذا لم يرسل المستشعر أي حدث خلال 3 ثوانٍ (مثل المحاكي أو جهاز لا يدعم البوصلة)
    _sensorTimeoutTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _lastEvent == null) {
        setState(() {
          _noSensorAvailable = true;
        });
      }
    });

    _compassSubscription = stream.listen(
      (event) {
        if (!mounted) return;
        _sensorTimeoutTimer?.cancel();
        setState(() {
          _lastEvent = event;
          _noSensorAvailable = false;
        });
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _noSensorAvailable = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _sensorTimeoutTimer?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // أثناء انتظار الاتصال بالمستشعر في أول 3 ثوانٍ
    if (_lastEvent == null && !_noSensorAvailable) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'جاري الاتصال بمستشعر البوصلة...',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      );
    }

    final double normalizedBearing = (widget.qiblaBearing + 360) % 360;
    final double? heading = _lastEvent?.heading;
    final bool hasLiveSensor = heading != null && !_noSensorAvailable;

    final double currentDirection = hasLiveSensor ? heading : 0.0;

    double diff = (widget.qiblaBearing - currentDirection).abs() % 360;
    if (diff > 180) diff = 360 - diff;

    if (hasLiveSensor && diff < 3.0) {
      if (!_isAligned) {
        _isAligned = true;
        HapticFeedback.heavyImpact();
      }
    } else {
      _isAligned = false;
    }

    final double compassAngle = (currentDirection * (math.pi / 180) * -1);
    final double qiblaAngle = ((widget.qiblaBearing - currentDirection) * (math.pi / 180));

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // مؤشر حالة المحاذاة أو زاوية القبلة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: _isAligned
                    ? Colors.green.withValues(alpha: 0.2)
                    : Theme.of(context).cardColor.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isAligned ? Colors.green : Colors.amber.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                _isAligned
                    ? "أنت في اتجاه القبلة الآن ✓"
                    : "زاوية القبلة: ${normalizedBearing.toStringAsFixed(1)}°",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: _isAligned ? Colors.green : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

            if (!hasLiveSensor) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                child: Text(
                  'تنبيه: جهازك أو المحاكي لا يحتوي على مستشعر بوصلة مغناطيسي (Magnetometer). يتم توجيه السهم نحو القبلة بالنسبة للشمال (0°).',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.sp,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],

            SizedBox(height: 2.h),

            // رسم البوصلة وسهم القبلة
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: compassAngle,
                  child: SizedBox(
                    height: 40.h,
                    width: 80.w,
                    child: Image.asset(AppImages.compusImg, fit: BoxFit.contain),
                  ),
                ),
                Transform.rotate(
                  angle: qiblaAngle,
                  child: SizedBox(
                    height: 40.h,
                    width: 80.w,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: _isAligned ? const Color(0xFFC49F63) : Colors.green,
                              size: 35.sp,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "القبلة",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: _isAligned
                                    ? const Color(0xFFC49F63)
                                    : Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            if (!hasLiveSensor)
              TextButton.icon(
                onPressed: _startCompassListening,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'إعادة محاولة قراءة المستشعر',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
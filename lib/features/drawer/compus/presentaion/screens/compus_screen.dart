import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/features/drawer/compus/presentaion/cubit/compus_cubit.dart';
import 'package:islamic_app/features/drawer/compus/presentaion/cubit/compus_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'dart:math' as math;
import 'package:islamic_app/core/di/service_locator.dart'; // الـ sl بتاعك


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
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              const SizedBox(height: 40),
              AppBarDrawerScreensWidget(back: true),


              Expanded(
                child: BlocBuilder<QiblaCubit, QiblaState>(
                  builder: (context, state) {
                    if (state is QiblaLoading || state is QiblaInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (state is QiblaPermissionDenied) {
                      return _buildPermissionSheet(context);
                    }
                    else if (state is QiblaSuccess) {
                      return _CompassWidget(qiblaBearing: state.qiblaBearing);
                    }
                    return const SizedBox();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionSheet(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('نحتاج صلاحية الموقع وتفعيل الـ GPS لتحديد القبلة'),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('المحاولة مرة أخرى'),
            onPressed: () {
              context.read<QiblaCubit>().getQiblaDirection();
            },
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error reading heading: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          double? direction = snapshot.data!.heading;

          if (direction == null) {
            return const Center(child: Text("جهازك لا يدعم مستشعرات البوصلة!"));
          }

          double diff = (widget.qiblaBearing - direction).abs() % 360;
          if (diff > 180) diff = 360 - diff;

          if (diff < 2.0) {
            if (!_isAligned) {
              _isAligned = true;
              HapticFeedback.heavyImpact();
            }
          } else {
            _isAligned = false;
          }

          double compassAngle = (direction * (math.pi / 180) * -1);
          double qiblaAngle = ((widget.qiblaBearing - direction) * (math.pi / 180));

          return Stack(
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: _isAligned
                                  ? const Color(0xFFC49F63)
                                  : Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
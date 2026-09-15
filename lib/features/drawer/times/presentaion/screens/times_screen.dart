import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/list_tile_times_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/drawer/times/presentaion/cubit/times_cubit.dart';
import 'package:islamic_app/features/drawer/times/presentaion/cubit/times_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:islamic_app/core/di/service_locator.dart'; // 💡 لازم تستدعي الـ sl

class TimesScreen extends StatelessWidget {
  const TimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider<TimesCubit>(
      create: (context) => sl<TimesCubit>()..getTimes(),
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
              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<TimesCubit, TimesState>(
                  builder: (context, state) {
                    if (state is TimesLoading || state is TimesInitial) {
                      return Center(child: CircularProgressIndicator(color: theme.dividerColor));
                    }
                    else if (state is TimesError) {
                      return Center(
                          child: TextNormalWidget(
                            decorationColor:  theme.textTheme.titleLarge!.color!
                              ,maxLines: 1,
                              text: state.message, size: 18.sp, color: Colors.red, weight: FontWeight.bold, decoration: TextDecoration.none)
                      );
                    }
                    else if (state is TimesSuccess) {
                      final cubit = context.read<TimesCubit>();

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                                width: 80.w,
                                child: Center(
                                    child: TextNormalWidget(
                                      decorationColor:  theme.textTheme.titleLarge!.color!,
                                        text: "مواقيت الصلاة في ${state.cityName}",
                                        size: 18.sp,
                                        color: theme.textTheme.titleLarge!.color!,
                                        decoration: TextDecoration.none,
                                        maxLines: 1,
                                        weight: FontWeight.bold))),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: 80.w,
                                child: Center(
                                    child: TextNormalWidget(
                                      decorationColor:  theme.textTheme.titleLarge!.color!,
                                        text: state.gregorianDate,
                                        size: 18.sp,
                                        color: theme.textTheme.titleLarge!.color!,
                                        decoration: TextDecoration.none,
                                        maxLines: 1,
                                        weight: FontWeight.bold))),
                            SizedBox(
                                width: 80.w,
                                child: Center(
                                    child: TextNormalWidget(
                                      decorationColor:  theme.textTheme.titleLarge!.color!,
                                        text: state.hijriDate,
                                        size: 18.sp,
                                        color: theme.textTheme.titleLarge!.color!,
                                        decoration: TextDecoration.none,
                                        maxLines: 1,
                                        weight: FontWeight.bold))),
                            SizedBox(
                                width: 60.w,
                                child: Center(
                                    child: TextNormalWidget(
                                      decorationColor: theme.textTheme.titleLarge!.color! ,
                                        text: state.cityName,
                                        size: 18.sp,
                                        color: theme.textTheme.titleLarge!.color!,
                                        decoration: TextDecoration.none,
                                        maxLines: 1,
                                        weight: FontWeight.bold))),
                            const SizedBox(height: 20),


                            // ================= قائمة المواقيت =================

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.imsak), trailing: "الإمساك", img: AppImages.fajrImg),

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.fajr), trailing: "الفجر", img: AppImages.fajrImg),

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.sunrise), trailing: "الشروق", img: AppImages.fajrImg), // تقدر تغير الصورة لو عندك صورة للشروق

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.duhr), trailing: "الظهر", img: AppImages.zohrImg),

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.asr), trailing: "العصر", img: AppImages.asrImg),

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.sunset), trailing: "الغروب", img: AppImages.magrebImg),

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.magreb), trailing: "المغرب", img: AppImages.magrebImg),

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.isha), trailing: "العشاء", img: AppImages.eashaImg),

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.midnight), trailing: "منتصف الليل", img: AppImages.eashaImg), // تقدر تغير الصورة بصورة قمر أو ليل

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.firstthird), trailing: "الثلث الأول", img: AppImages.eashaImg),

                            ListTileTimesWidget(theme: theme, time: cubit.convertTime(state.times.lastthird), trailing: "الثلث الأخير", img: AppImages.eashaImg),

                            const SizedBox(height: 20),
                          ],
                        ),
                      );
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
}
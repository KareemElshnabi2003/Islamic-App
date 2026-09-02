import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_app_widget.dart';
import 'package:islamic_app/core/widgets/drawer_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/all_sour_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:islamic_app/core/di/service_locator.dart'; // مسار الـ SL

import '../../../../../core/widgets/line_widget.dart';
import '../widgets/top_home_page_widget.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/all_sour_cubit.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (context) => sl<AllSourCubit>()..getAllSour(),
      child: Scaffold(
        drawer: Drawer(
            child: DrawerWidget(       onPressDoaa: () { context.push(Routes.doaaCatScreen); },
              onPressVideos: () { context.push(Routes.videosTypeScreen); },
              onPressCompus: () { context.push(Routes.compusScreen); },
              val: isDarkMode,
              theme: theme,
              onChangeTheme: (v) { context.read<ThemeCubit>().toggleTheme(); },
              onPressAzan: () { context.push(Routes.azanSettingScreen); },
              onPressStories: () { context.push(Routes.storiesScreen); },
              onPressTheme: () { context.read<ThemeCubit>().toggleTheme(); },
              onPressTimes: () { context.push(Routes.timesScreen); },
              onPressZekr: () { context.push(Routes.notifyZekrScreen); },
            )
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Container(
          height: 100.h,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg), fit: BoxFit.fill)
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              AppBarAppWidget(back: false),
              const SizedBox(height: 10),
              TopHomePageWidget(),
              const SizedBox(height: 10),
              LineWidget(color: theme.dividerColor, isVertical: false, thick: 4, size: 100.w),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    SizedBox(width: 40.w, child: Center(child: TextNormalWidget(decorationColor: theme.textTheme.titleLarge!.color!,text: "اسم السورة", size: 20.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, maxLines: 1, weight: FontWeight.bold))),
                    SizedBox(width: 10.w, child: LineWidget(color: theme.dividerColor, isVertical: true, thick: 4, size: 5.7.h)),
                    SizedBox(width: 40.w, child: Center(child: TextNormalWidget(decorationColor: theme.textTheme.titleLarge!.color!,text: "نوع السورة", size: 20.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, maxLines: 1, weight: FontWeight.bold))),
                  ],
                ),
              ),
              LineWidget(color: theme.dividerColor, isVertical: false, thick: 4, size: 100.w),

              // ================= عرض السور =================
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: BlocBuilder<AllSourCubit, AllSourState>(
                    builder: (context, state) {
                      if (state is AllSourLoading) {
                        return Center(child: CircularProgressIndicator(color: theme.dividerColor));
                      } else if (state is AllSourError) {
                        return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
                      } else if (state is AllSourSuccess) {
                        return ListView.builder(
                          itemCount: state.allSour.length,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final sura = state.allSour[index];
                            return InkWell(
                              onTap: () {
                                context.push(Routes.souraScreen, extra: sura.id);
                              },
                              child: Row(
                                children: [
                                  SizedBox(width: 40.w, height: 6.h, child: Center(child: TextNormalWidget( decorationColor: theme.textTheme.titleLarge!.color!,text: sura.name, size: 19.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, maxLines: 1, weight: FontWeight.w600))),
                                  SizedBox(width: 10.w, height: 6.h, child: LineWidget(color: theme.dividerColor, isVertical: true, thick: 4, size: 5.h)),
                                  SizedBox(height: 6.h, width: 40.w, child: Center(child: TextNormalWidget(decorationColor: theme.textTheme.titleLarge!.color!,text: sura.makia == 1 ? "مكية" : "مدنية", size: 19.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, maxLines: 1, weight: FontWeight.w600))),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
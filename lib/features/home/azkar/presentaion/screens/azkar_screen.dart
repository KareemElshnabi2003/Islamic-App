import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/app_colors.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_app_widget.dart';
import 'package:islamic_app/core/widgets/drawer_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/home/azkar/presentaion/cubit/sebha_cubit.dart';
import 'package:islamic_app/features/home/azkar/presentaion/cubit/sebha_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';


class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (context) => SebhaCubit(),
      child: Scaffold(
        drawer: Drawer(
            child: DrawerWidget(       onPressDoaa: () { context.push(Routes.doaaCatScreen); },
              onPressVideos: () { context.push(Routes.videosTypeScreen); },
              onPressCompus: () { context.push(Routes.compusScreen); },
              val: isDarkMode,
              theme: theme,
              onChangeTheme: (v) { context.read<ThemeCubit>().toggleTheme(); },
              onPressAzan: () { context.push(Routes.azanScreen); },
              onPressStories: () { context.push(Routes.storiesScreen); },
              onPressTheme: () { context.read<ThemeCubit>().toggleTheme(); },
              onPressTimes: () { context.push(Routes.timesScreen); },
              onPressZekr: () { context.push(Routes.notifyZekrScreen); },
            )
        ),
        body: Container(
          height: 100.h,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg), fit: BoxFit.fill)
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              AppBarAppWidget(back: false),
              const SizedBox(height: 50),

              BlocBuilder<SebhaCubit, SebhaState>(
                builder: (context, state) {
                  final cubit = context.read<SebhaCubit>();

                  return Column(
                    children: [
                      SizedBox(
                        height: 45.h,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [

                            Positioned(
                              top: 7.5.h,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  cubit.increment();
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: state.rotationAngle,
                                      child: Image.asset(AppImages.sebhaImg, width: 80.w, height: 35.h, fit: BoxFit.contain),
                                    ),
                                    TextNormalWidget(
                                        text: "اضغط",
                                        size: 20.sp,
                                        color: theme.textTheme.bodyMedium!.color!,
                                        decoration: TextDecoration.none,
                                        decorationColor: theme.textTheme.bodyMedium!.color!,
                                        maxLines: 1,
                                        weight: FontWeight.bold
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                                top:5.h,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 3.w),
                                  child: Image.asset(AppImages.headSbhaImg, width: 20.w, height: 10.h),
                                )
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        width: 25.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                            color: AppColors.lineLight,
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: TextNormalWidget(
                            text: "${state.counter}",
                            size: 20.sp,
                            color: theme.textTheme.bodyMedium!.color!,
                            decoration: TextDecoration.none,
                            decorationColor: theme.textTheme.bodyMedium!.color!,
                            maxLines: 1,
                            weight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextNormalWidget(
                          text: cubit.azkar[state.zekrIndex],
                          size: 22.sp,
                          color: theme.textTheme.bodyMedium!.color!,
                          decoration: TextDecoration.none,
                          decorationColor: theme.textTheme.bodyMedium!.color!,
                          maxLines: 1,
                          weight: FontWeight.bold
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
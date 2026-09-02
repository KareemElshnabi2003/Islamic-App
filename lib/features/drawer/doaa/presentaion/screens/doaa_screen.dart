import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/next_previous_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/doaa_reader_state.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/oaa_reader_cubit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';

class DoaaDetailsScreen extends StatelessWidget {
  final String title;

  const DoaaDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    final readerCubit = context.read<DoaaReaderCubit>();

    return Scaffold(
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
              child: BlocBuilder<DoaaReaderCubit, DoaaReaderState>(
                builder: (context, state) {
                  if (readerCubit.duas.isEmpty) {
                    return Center(
                      child: TextNormalWidget(
                        text: "لا توجد أدعية في هذا القسم",
                        size: 16.sp,
                        color: theme.textTheme.titleLarge!.color!,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                        maxLines: 1,
                        weight: FontWeight.bold,
                      ),
                    );
                  }

                  final doaa = readerCubit.duas[state.currentIndex];

                  // تحديد حالة زراير التالي والسابق
                  final bool hasNext = state.currentIndex < readerCubit.duas.length - 1;
                  final bool hasPrev = state.currentIndex > 0;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor.withOpacity(.6),
                              borderRadius: BorderRadius.circular(25)),
                          width: 90.w,
                          constraints: BoxConstraints(minHeight: 50.h),
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // عنوان القسم (زي أذكار الصباح)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextNormalWidget(
                                      text: title,
                                      size: 18.sp,
                                      color: theme.textTheme.titleLarge!.color!,
                                      decoration: TextDecoration.none,
                                      decorationColor: theme.textTheme.titleLarge!.color!,
                                      maxLines: 1,
                                      weight: FontWeight.w700),
                                ],
                              ),
                              const SizedBox(height: 10),
                              LineWidget(isVertical: false, size: 70.w, color: theme.dividerColor, thick: 2),
                              const SizedBox(height: 20),

                              // نص الدعاء
                              TextNormalWidget(
                                  text: doaa.arabic,
                                  size: 18.sp,
                                  color: theme.textTheme.titleLarge!.color!,
                                  decoration: TextDecoration.none,
                                  decorationColor: theme.textTheme.titleLarge!.color!,
                                  maxLines: 100,
                                  weight: FontWeight.w600),

                              const SizedBox(height: 30),
                              LineWidget(isVertical: false, size: 40.w, color: theme.dividerColor, thick: 1),
                              const SizedBox(height: 15),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextNormalWidget(
                                        text: "التكرار: ${doaa.repeat}",
                                        size: 16.sp,
                                        color: theme.primaryColor,
                                        decoration: TextDecoration.none,
                                        decorationColor: Colors.transparent,
                                        maxLines: 1,
                                        weight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // زراير التحكم
                        NextPreviusWidget(
                          onPressNext: hasNext ? readerCubit.nextDoaa : null,
                          onPressPrev: hasPrev ? readerCubit.prevDoaa : null,
                          theme: theme,
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/widgets/top_doaa_widget.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/doaa_cubit.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/doaa_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';

class DoaaCatScreen extends StatelessWidget {
  const DoaaCatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

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
            const SizedBox(height: 10),
            Column(
              children: [
                TopDoaaWidget(),
                const SizedBox(height: 10),
                LineWidget(color: theme.dividerColor, isVertical: false, thick: 4, size: 100.w),
                Padding(
                  padding: EdgeInsets.only(right: 5.w, left: 5.w),
                  child: SizedBox(
                      height: 5.5.h,
                      width: 40.w,
                      child: Center(
                          child: TextNormalWidget(
                              text: "أدعية المسلم",
                              size: 20.sp,
                              color: theme.textTheme.titleLarge!.color!,
                              decoration: TextDecoration.none,
                              decorationColor: theme.textTheme.titleLarge!.color!,
                              maxLines: 1,
                              weight: FontWeight.bold))),
                ),
                LineWidget(color: theme.dividerColor, isVertical: false, thick: 4, size: 100.w),

                // التعديل هنا: استخدام DoaaCubit و DoaaState
                BlocBuilder<DoaaCubit, DoaaState>(
                  builder: (context, state) {
                    if (state is DoaaLoading || state is DoaaInitial) {
                      return Container(
                        height: 52.h,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    } else if (state is DoaaSuccess) {
                      return Container(
                        height: 52.h,
                        padding: EdgeInsets.only(right: 5.w, left: 5.w),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.categories.length,
                          padding: EdgeInsets.zero,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category = state.categories[index];

                            // التعديل هنا: تحويل الـ ID الإنجليزي لاسم عربي شيك
                            final arabicName = context.read<DoaaCubit>().getArabicCategoryName(category.id);

                            return InkWell(
                              onTap: () {
                                context.push(Routes.doaaDetailsScreen, extra: {
                                  'duas': category.duas,
                                  'title': arabicName,
                                });                              },
                              child: SizedBox(
                                width: 40.w,
                                height: 6.h,
                                child: Center(
                                  child: TextNormalWidget(
                                    text: arabicName, // عرض الاسم العربي هنا
                                    size: 19.sp,
                                    color: theme.textTheme.titleLarge!.color!,
                                    decoration: TextDecoration.none,
                                    decorationColor: theme.textTheme.titleLarge!.color!,
                                    maxLines: 1,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is DoaaError) {
                      return Container(
                        height: 52.h,
                        alignment: Alignment.center,
                        child: Text(state.message),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
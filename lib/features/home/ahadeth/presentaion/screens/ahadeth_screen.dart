import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/di/service_locator.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_app_widget.dart';
import 'package:islamic_app/core/widgets/drawer_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';
import '../widgets/top_ahadeth_widget.dart';
import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/hadeth_author_cubit.dart';
import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/hadeth_author_state.dart';

class AhadethScreen extends StatelessWidget {
  const AhadethScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (context) => sl<HadethAuthorCubit>()..getAuthors(),
      child: Scaffold(
        drawer: Drawer(
            child: DrawerWidget(
              onPressDoaa: () { context.push(Routes.doaaCatScreen); },
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
              image: DecorationImage(
                  image: AssetImage(isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg),
                  fit: BoxFit.fill
              )
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              AppBarAppWidget(back: false),
              const SizedBox(height: 10),
              TopAhadethWidget(),
              const SizedBox(height: 10),
              LineWidget(color: theme.dividerColor, isVertical: false, thick: 4, size: 100.w),
              Padding(
                padding: EdgeInsets.only(right: 5.w, left: 5.w),
                child: SizedBox(
                    height: 5.5.h,
                    width: 40.w,
                    child: Center(
                        child: TextNormalWidget(
                            decorationColor: theme.textTheme.titleLarge!.color!,
                            text: "الأحاديث",
                            size: 20.sp,
                            color: theme.textTheme.titleLarge!.color!,
                            decoration: TextDecoration.none,
                            maxLines: 1,
                            weight: FontWeight.bold
                        )
                    )
                ),
              ),
              LineWidget(color: theme.dividerColor, isVertical: false, thick: 4, size: 100.w),


              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w, left: 5.w),
                  child: BlocBuilder<HadethAuthorCubit, HadethAuthorState>(
                    builder: (context, state) {
                      if (state is HadethAuthorLoading) {
                        return Center(child: CircularProgressIndicator(color: theme.dividerColor));
                      } else if (state is HadethAuthorError) {
                        return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                      } else if (state is HadethAuthorSuccess) {
                        return ListView.builder(
                          // مسحنا shrinkWrap عشان ملهاش لازمة جوه الـ Expanded
                          itemCount: state.authors.length,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final author = state.authors[index];
                            return InkWell(
                              onTap: () {
                                context.push(Routes.hadethScreen, extra: author.key);
                              },
                              child: SizedBox(
                                  width: 40.w,
                                  height: 6.h,
                                  child: Center(
                                      child: TextNormalWidget(
                                          decorationColor: theme.textTheme.titleLarge!.color!,
                                          text: author.arabicName,
                                          size: 19.sp,
                                          color: theme.textTheme.titleLarge!.color!,
                                          decoration: TextDecoration.none,
                                          maxLines: 1,
                                          weight: FontWeight.w600
                                      )
                                  )
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
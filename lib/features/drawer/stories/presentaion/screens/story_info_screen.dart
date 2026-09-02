import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/next_previous_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/drawer/stories/presentaion/cubit/story_cubit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';
import '../cubit/story_names_state.dart';

class StoryInfoScreen extends StatelessWidget {
  const StoryInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<StoriesCubit, StoryNamesState>(
                builder: (context, state) {
                  if (state is StoryNamesSuccess) {
                    final currentStory = state.stories[state.currentIndex];

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                                color: theme.scaffoldBackgroundColor.withOpacity(.6),
                                borderRadius: BorderRadius.circular(25)),
                            width: 90.w,
                            height: 70.h,
                            padding: EdgeInsets.all(3.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextNormalWidget(
                                        text: currentStory.name,
                                        size: 17.sp,
                                        color: theme.textTheme.titleLarge!.color!,
                                        decoration: TextDecoration.none,
                                        decorationColor: theme.textTheme.titleLarge!.color!,
                                        maxLines: 1,
                                        weight: FontWeight.w700),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                                LineWidget(isVertical: false, size: 70.w, color: theme.dividerColor, thick: 2),
                                const SizedBox(height: 10),




                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextNormalWidget(
                                            text: currentStory.storyTitle,
                                            size: 16.sp,
                                            color: theme.textTheme.titleLarge!.color!,
                                            decoration: TextDecoration.none,
                                            decorationColor: theme.textTheme.titleLarge!.color!,
                                            maxLines: 2,
                                            weight: FontWeight.bold),
                                        const SizedBox(height: 15),


                                        if (currentStory.img.isNotEmpty)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.network(
                                              currentStory.img,
                                              height: 22.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return SizedBox(
                                                  height: 22.h,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      color: theme.primaryColor,
                                                    ),
                                                  ),
                                                );
                                              },
                                              errorBuilder: (context, error, stackTrace) {
                                                return const SizedBox();
                                              },
                                            ),
                                          ),
                                        const SizedBox(height: 15),
                                        TextNormalWidget(
                                            text: "${currentStory.brief}\n\n${currentStory.story}",
                                            size: 15.sp,
                                            color: theme.textTheme.titleLarge!.color!,
                                            decoration: TextDecoration.none,
                                            decorationColor: theme.textTheme.titleLarge!.color!,
                                            maxLines: 2000,
                                            weight: FontWeight.w600),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          NextPreviusWidget(
                            onPressNext: () {
                              context.read<StoriesCubit>().nextStory();
                            },
                            onPressPrev: () {
                              context.read<StoriesCubit>().prevStory();
                            },
                            theme: theme,
                          )
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
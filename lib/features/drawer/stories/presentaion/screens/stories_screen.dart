import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/drawer/stories/presentaion/cubit/story_cubit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';
import '../widgets/top_story_widget.dart';
import '../cubit/story_names_state.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

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
                TopStoryWidget(),
                const SizedBox(height: 10),
                LineWidget(color: theme.dividerColor, isVertical: false, thick: 4, size: 100.w),
                Padding(
                  padding: EdgeInsets.only(right: 5.w, left: 5.w),
                  child: SizedBox(
                      height: 5.5.h,
                      width: 40.w,
                      child: Center(
                          child: TextNormalWidget(
                              text: "قصص الانبياء",
                              size: 20.sp,
                              color: theme.textTheme.titleLarge!.color!,
                              decoration: TextDecoration.none,
                              decorationColor: theme.textTheme.titleLarge!.color!,
                              maxLines: 1,
                              weight: FontWeight.bold))),
                ),
                LineWidget(color: theme.dividerColor, isVertical: false, thick: 4, size: 100.w),

                BlocBuilder<StoriesCubit, StoryNamesState>(
                  builder: (context, state) {
                    if (state is StoryNamesLoading) {
                      return Container(
                        height: 52.h,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    } else if (state is StoryNamesSuccess) {
                      return Container(
                        height: 52.h,
                        padding: EdgeInsets.only(right: 5.w, left: 5.w),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.stories.length,
                          padding: EdgeInsets.zero,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final story = state.stories[index];
                            return InkWell(
                              onTap: () {
                                context.read<StoriesCubit>().setSelectedIndex(index);
                                context.push(Routes.storyInfoScreen);
                              },
                              child: SizedBox(
                                width: 40.w,
                                height: 6.h,
                                child: Center(
                                  child: TextNormalWidget(
                                    text: story.name,
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
                    } else if (state is StoryNamesError) {
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
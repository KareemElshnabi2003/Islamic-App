import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/di/service_locator.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/next_previous_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';
import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/ahadeth_cubit.dart';
import 'package:islamic_app/features/home/ahadeth/presentaion/cubit/ahadeth_state.dart';

class HadethScreen extends StatelessWidget {
  final String authorKey;

  const HadethScreen({super.key, required this.authorKey});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (context) => sl<AhadethCubit>()..gethadeth(author: authorKey),
      child: Scaffold(
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
              AppBarDrawerScreensWidget(back: true),
              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<AhadethCubit, AhadethState>(
                  builder: (context, state) {
                    if (state is HadethLoading) {
                      return Center(child: CircularProgressIndicator(color: theme.dividerColor));
                    } else if (state is HadethError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    } else if (state is HadethSuccess) {
                      if (state.ahadeth.isEmpty) {
                        return const Center(child: Text("لا توجد أحاديث"));
                      }

                      final currentIndex = state.currentIndex ?? 0;
                      final currentHadeth = state.ahadeth[currentIndex];

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor.withOpacity(.6),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              width: 90.w,

                              padding: EdgeInsets.all(5.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextNormalWidget(
                                          decorationColor: theme.textTheme.titleLarge!.color!,
                                          text: "حديث ${currentHadeth.hadethNum}",
                                          size: 17.sp,
                                          color: theme.textTheme.titleLarge!.color!,
                                          decoration: TextDecoration.none,
                                          maxLines: 1,
                                          weight: FontWeight.w700
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  LineWidget(isVertical: false, size: 70.w, color: theme.dividerColor, thick: 2),
                                  const SizedBox(height: 15),

                                  TextNormalWidget(
                                      text: currentHadeth.body,
                                      size: 16.sp,
                                      color: theme.textTheme.titleLarge!.color!,
                                      decorationColor: theme.textTheme.titleLarge!.color!,
                                      decoration: TextDecoration.none,
                                      maxLines: 10000,
                                      weight: FontWeight.w600
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            NextPreviusWidget(
                                onPressNext: () {
                                  context.read<AhadethCubit>().nextHadeth();
                                },
                                onPressPrev: () {
                                  context.read<AhadethCubit>().prevHadeth();
                                },
                                theme: theme
                            ),
                            const SizedBox(height: 30),
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/drawer/zekr/presentaion/cubit/zekr_notify_cubit.dart';
import 'package:islamic_app/features/drawer/zekr/presentaion/cubit/zekr_notify_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';

class NotifyZekrScreen extends StatelessWidget {
  const NotifyZekrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    final List<Map<String, dynamic>> times = [
      {"title": "كل 5 دقائق", "value": 5},
      {"title": "كل 10 دقائق", "value": 10},
      {"title": "كل 20 دقيقة", "value": 20},
      {"title": "كل 30 دقيقة", "value": 30},
      {"title": "كل ساعة", "value": 60},
      {"title": "كل ساعتين", "value": 120},
    ];



    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        height: 100.h,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg),
                fit: BoxFit.fill)),
        child: BlocBuilder<ZekrNotificationCubit, ZekrNotificationState>(
          builder: (context, state) {
            final cubit = context.read<ZekrNotificationCubit>();

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  AppBarDrawerScreensWidget(back: true),
                  const SizedBox(height: 40),

                  SizedBox(
                      width: 80.w,
                      child: Center(
                          child: TextNormalWidget(
                              text: "أذكار",
                              size: 20.sp,
                              color: theme.textTheme.bodyMedium!.color!,
                              decoration: TextDecoration.none,
                              decorationColor: theme.textTheme.bodyMedium!.color!,
                              maxLines: 1,
                              weight: FontWeight.bold))),
                  LineWidget(
                      isVertical: false,
                      size: 40.w,
                      color: theme.dividerColor,
                      thick: 2),
                  const SizedBox(height: 20),

                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      onTap: () {
                        cubit.toggleNotification(!state.isEnabled);
                      },
                      trailing: Switch(
                        value: state.isEnabled,
                        onChanged: (v) {
                          cubit.toggleNotification(v);
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                      ),
                      title: TextNormalWidget(
                          text: "هل تريد تفعيل إشعار الذكر ؟",
                          size: 15.sp,
                          color: theme.textTheme.bodyMedium!.color!,
                          decoration: TextDecoration.none,
                          decorationColor: theme.textTheme.bodyMedium!.color!,
                          maxLines: 1,
                          weight: FontWeight.bold),
                    ),
                  ),

                  Container(
                    width: 100.w,
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextNormalWidget(
                              text: "التوقيت",
                              size: 20.sp,
                              color: theme.textTheme.bodyMedium!.color!,
                              decoration: TextDecoration.none,
                              decorationColor: theme.textTheme.bodyMedium!.color!,
                              maxLines: 1,
                              weight: FontWeight.bold),
                          LineWidget(
                              isVertical: false,
                              size: 20.w,
                              color: theme.dividerColor,
                              thick: 2),
                        ]),
                  ),
                  const SizedBox(height: 20),

                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Opacity(
                        opacity: state.isEnabled ? 1.0 : 0.5,
                        child: IgnorePointer(
                          ignoring: !state.isEnabled,
                          child: SizedBox(
                            width: 100.w,
                            child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => RadioListTile<int>(
                                  activeColor: Colors.green,
                                  groupValue: state.interval,
                                  value: times[index]['value'],
                                  onChanged: (v) {
                                    if (v != null) cubit.changeInterval(v);
                                  },
                                  title: TextNormalWidget(
                                      text: times[index]['title'],
                                      size: 15.sp,
                                      color: theme.textTheme.bodyMedium!.color!,
                                      decoration: TextDecoration.none,
                                      decorationColor: theme.textTheme.bodyMedium!.color!,
                                      maxLines: 1,
                                      weight: FontWeight.bold),
                                ),
                                separatorBuilder: (context, index) => const SizedBox(height: 10),
                                itemCount: times.length),
                          ),
                        ),
                      )),




                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/bottom_sheet_quraa_widget.dart';
import 'package:islamic_app/core/widgets/next_previous_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/ayat_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:islamic_app/core/di/service_locator.dart';

import '../../../../../core/widgets/line_widget.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/ayat_cubit.dart';

class SouraScreen extends StatelessWidget {
  final int suraId;
  const SouraScreen({super.key, required this.suraId});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (context) => sl<AyatCubit>()..getAyat(id: suraId),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Container(
          height: 100.h,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg), fit: BoxFit.fill)
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              AppBarDrawerScreensWidget(back: true),
              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<AyatCubit, AyatState>(
                  builder: (context, state) {
                    if (state is AyatLoading) {
                      return Center(child: CircularProgressIndicator(color: theme.dividerColor));
                    } else if (state is AyatError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    } else if (state is AyatSuccess) {

                      // دمج الآيات كلها في نص واحد
                      final fullSurahText = state.ayat.varses.map((e) => "${e.ayah} ﴿${e.id}﴾").join(" ");
                      // دالة لتحويل الأرقام الإنجليزية لعربية

                      return Column(
                        children: [
                          // 💡 الآيات جوه Expanded عشان تاخد المساحة الباقية وتعمل Scroll لوحدها
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(color: theme.scaffoldBackgroundColor.withOpacity(.6), borderRadius: BorderRadius.circular(25)),
                                    width: 90.w,
                                    padding: EdgeInsets.all(5.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextNormalWidget(decorationColor: theme.textTheme.titleLarge!.color!,text: "سورة ${state.ayat.sura.name}", size: 16.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, maxLines: 1, weight: FontWeight.w700),
                                            const SizedBox(width: 15),

                                            // زر التشغيل واختيار القارئ
                                            IconButton(
                                                onPressed: () {
                                                  bottomSheetQuraaWidget(
                                                    context: context,
                                                    theme: theme,
                                                  );
                                                },
                                                icon: Icon(
                                                  state.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled_rounded,
                                                  color: theme.iconTheme.color,
                                                  size: 25.sp,
                                                )
                                            ),
                                          ],
                                        ),
                                        LineWidget(isVertical: false, size: 70.w, color: theme.dividerColor, thick: 2),
                                        const SizedBox(height: 15),

                                        // نص السورة
                                        SizedBox(
                                          width: double.infinity,
                                          child:
                                            Text(
                                              fullSurahText,
                                              textAlign: TextAlign.center,
                                              textDirection: TextDirection.rtl,
                                              style: GoogleFonts.amiri( // 💡 استخدام خط أميري من جوجل
                                                fontSize: 17.sp,
                                                color: theme.textTheme.titleLarge!.color!,
                                                height: 2.0,
                                                fontWeight: FontWeight.w600
                                              ),
                                            )


                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),

                          // 💡 الزراير بقت بره السكرول وثابتة تحت
                          NextPreviusWidget(
                              onPressNext: () => context.read<AyatCubit>().nextSoura(),
                              onPressPrev: () => context.read<AyatCubit>().prevSoura(),
                              theme: theme
                          ),
                          const SizedBox(height: 30), // مسافة تحت الزراير
                        ],
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
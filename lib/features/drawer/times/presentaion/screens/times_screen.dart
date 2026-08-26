import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/bottom_sheet_map_widget.dart';
import 'package:islamic_app/core/widgets/list_tile_times_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class TimesScreen extends StatelessWidget {
  const TimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme =Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(

          height: 100.h,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(isDarkMode?AppImages.bgDarkImg:AppImages.bgLightImg),fit: BoxFit.fill)
          ),

        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            AppBarDrawerScreensWidget(back: true),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                width: 80.w,
                child: Center(child: TextNormalWidget(text: "مواقيت الصلاة في القاهرة", size: 20.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold))),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                width: 80.w,
                child: Center(child: TextNormalWidget(text: "الاثنين , 21 اكتوبر 2026", size: 18.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold))),
            SizedBox(
                width: 60.w,
                child: Center(child: TextNormalWidget(text: "القاهرة", size: 18.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold))),



            const SizedBox(
              height: 10,
            ),
       ListTileTimesWidget(theme: theme, time: "4:30 AM", trailing: "الفجر", img: AppImages.fajrImg),

            ListTileTimesWidget(theme: theme, time: "4:30 AM", trailing: "الفجر", img: AppImages.zohrImg),


            ListTileTimesWidget(theme: theme, time: "4:30 AM", trailing: "الفجر", img: AppImages.asrImg),


            ListTileTimesWidget(theme: theme, time: "4:30 AM", trailing: "الفجر", img: AppImages.magrebImg),

            ListTileTimesWidget(theme: theme, time: "4:30 AM", trailing: "الفجر", img: AppImages.eashaImg),


            InkWell(
              onTap: (){
                //show bottom sheet with map
                bottomSheetMapWidget(theme: theme, context: context);
              },
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextNormalWidget(text: "تغيير الموقع", size: 16.sp, color: theme.dividerColor, decoration: TextDecoration.underline, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold) ,
                    Icon(Icons. location_on,color: theme.dividerColor,size: 20.sp,),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

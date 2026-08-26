import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/bottom_sheet_quraa_widget.dart';
import 'package:islamic_app/core/widgets/next_previous_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';

class SouraScreen extends StatefulWidget {
  const SouraScreen({super.key});

  @override
  State<SouraScreen> createState() => _SouraScreenState();
}
bool play=false;
class _SouraScreenState extends State<SouraScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(

      backgroundColor:theme.scaffoldBackgroundColor ,
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
              height: 20,
            ),
            SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(
                    height: 30,
                  ),
                      Container(
                        decoration: BoxDecoration(color:theme.scaffoldBackgroundColor.withOpacity(.6),borderRadius: BorderRadius.circular(25)),
                        width: 90.w,
                        height: 70.h,
                        padding: EdgeInsets.all(3.w),
                        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                      TextNormalWidget(text: "سورة البقرة", size: 16.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, decorationColor: theme.textTheme.titleLarge!.color!, maxLines: 1, weight: FontWeight.w700),
                      SizedBox(width: 15,),

                      IconButton(onPressed: (){

bottomSheetQuraaWidget(context: context,theme: theme, listQuraa: [
  {"name":'تست تستو'},

], onPressPlay: (){
  setState(() {
    play=true;
print("play   $play");
  });
}, onPressStop: (){
  setState(() {
    play=false;
    print("play   $play");

  });
}, play: play);



                      }, icon: Icon(Icons.play_circle_filled_rounded,color: theme.iconTheme.color,size: 23.sp,)),

                  ],
                ),
                LineWidget(isVertical: false, size: 70.w, color: theme.dividerColor, thick: 2),
                const SizedBox(
                  height: 10,
                ),

                SingleChildScrollView(child: TextNormalWidget(text: "تست تست تست ", size: 15.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, decorationColor: theme.textTheme.titleLarge!.color!, maxLines: 20, weight: FontWeight.w600)),


              ],
                        ),
                      ),

   NextPreviusWidget(onPressNext: (){}, onPressPrev: (){}, theme: theme)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

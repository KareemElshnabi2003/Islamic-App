
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/app_colors.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_app_widget.dart';
import 'package:islamic_app/core/widgets/drawer_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});


  @override
  Widget build(BuildContext context) {
    ThemeData theme =Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      drawer: Drawer(
          child:DrawerWidget(   onPressCompus:(){context.push(Routes.compusScreen);},val: isDarkMode,theme: theme,onChangeTheme: (v){
            context.read<ThemeCubit>().toggleTheme();
          },onPressAzan: (){
            context.push(Routes.azanScreen);
          },onPressStories: (){            context.push(Routes.storiesScreen);
          },onPressTheme: (){            context.read<ThemeCubit>().toggleTheme();
          },onPressTimes: (){            context.push(Routes.timesScreen);
          },onPressZekr: (){            context.push(Routes.notifyZekrScreen);
          },)
      ),
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
            AppBarAppWidget(back: false),
            const SizedBox(
              height: 50,
            ),

             SizedBox(
               height: 50.h,
               child: Stack(
                 clipBehavior: Clip.none,
                 children: [
                   Positioned(

                       bottom: 41.h,
                       right: 34.w,
                       left: 41.w,
                       child: Center(child: Image.asset(AppImages.headSbhaImg,width: 30.w,height: 10.h,))),
                   InkWell(
                       onTap:(){
                         // round sebha and ++ the num

                       },

                       child:Container(
                         width:90.w ,
                         height:40.h ,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           image: DecorationImage(image: AssetImage(AppImages.sebhaImg),fit: BoxFit.fill)
                         ),
                         child:              TextNormalWidget(text: "اضغط", size: 20.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

                       ) ,),
                 ],
               ),
             ),
            Container(
              padding:const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 30.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: AppColors.lineLight,
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: TextNormalWidget(text: "33", size: 20.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),

             TextNormalWidget(text: "سبحان الله", size: 22.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ],
        ),
      ),
    );
  }
}

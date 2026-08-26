import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_app_widget.dart';
import 'package:islamic_app/core/widgets/drawer_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';
import '../widgets/top_ahadeth_widget.dart';

class AhadethScreen extends StatelessWidget {
  const AhadethScreen({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeData theme =Theme.of(context);
    ScrollController scrolController=ScrollController();
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      drawer: Drawer(
          child:DrawerWidget(
            onPressCompus:(){context.push(Routes.compusScreen);},val: isDarkMode,theme: theme,onChangeTheme: (v){
            context.read<ThemeCubit>().toggleTheme();
          },onPressAzan: (){
            context.push(Routes.azanScreen);
          },onPressStories: (){            context.push(Routes.storiesScreen);
          },onPressTheme: (){            context.read<ThemeCubit>().toggleTheme();
          },onPressTimes: (){            context.push(Routes.timesScreen);
          },onPressZekr: (){            context.push(Routes.notifyZekrScreen);
          },)
      ),
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
            AppBarAppWidget(back: false),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                TopAhadethWidget(),
                const SizedBox(
                  height: 10,
                ),
                LineWidget(color:theme.dividerColor,isVertical:false,thick:4,size: 100.w,),
                Padding(
                  padding:  EdgeInsets.only(right:5.w ,left: 5.w),
                  child:
                      SizedBox(
                        height: 5.5.h,
                          width: 40.w,
                          child: Center(child: TextNormalWidget(text: "الاحاديث", size: 20.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, decorationColor: theme.textTheme.titleLarge!.color!, maxLines: 1, weight: FontWeight.bold))),



                ),

                LineWidget(color:theme.dividerColor,isVertical:false,thick:4,size: 100.w,),
                //list of quran

                Container(
                    height: 52.h,
                    padding:  EdgeInsets.only(right:5.w ,left: 5.w),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 50,

                      padding: EdgeInsets.zero,
                      controller:scrolController,
                      physics: AlwaysScrollableScrollPhysics(),

                      itemBuilder: (context, index) => InkWell(
                        onTap: (){
                          //go to soura
                          context.push(Routes.hadethScreen);
                        },

                        child:
                            SizedBox(
                                width: 40.w,
                                height: 6.h,
                                child: Center(child: TextNormalWidget(text: "اسم الحدييث", size: 19.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, decorationColor: theme.textTheme.titleLarge!.color!, maxLines: 1, weight: FontWeight.w600))),

                      ),)
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

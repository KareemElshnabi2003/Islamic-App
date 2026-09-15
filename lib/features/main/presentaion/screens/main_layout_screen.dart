import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/app_colors.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/drawer_widget.dart';

class MainLayoutScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

   const MainLayoutScreen({super.key, required this.navigationShell});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
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
        body: widget.navigationShell,

        bottomNavigationBar:_bottomNavigationBar(navigationShell:widget.navigationShell,theme: theme,items: items, itemCount: items.length)
      ),
    );
  }

  final List<Map<String, dynamic>> items = [
    {
      "title": "القرآن",
      "img": AppImages.quranImg,
    },
    {
      "title": "الاحاديث",
      "img": AppImages.ahadethImg,
    },
    {
      "title": "الاذكار",
      "img": AppImages.azkarImg,
    },
    {
      "title": "الراديو",
      "img": AppImages.radioImg,
    }
  ];

  Widget _bottomNavigationBar({required StatefulNavigationShell navigationShell,
  required List items, required int itemCount, required ThemeData theme}) {
   return Container(
     color: theme.primaryColor,
      height: 9.h,
      width: 100.w,
      padding: EdgeInsets.only(right: 4.w, left: 4.w, top: 1.h, bottom: 1.h),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 4.w),
        itemCount: itemCount,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final isSelected = index == navigationShell.currentIndex;
          return _bottomNavigationBarItem(
            selected: isSelected, 
            title: items[index]['title'], 
            img: items[index]['img'], 
            onPress: () {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            }, 
            selectedItemColor: theme.secondaryHeaderColor, 
            unSelectedItemColor: AppColors.primaryLight
          );
        },
      ),
    );
  }

  Widget _bottomNavigationBarItem({required bool selected,required String title,required String img,required  onPress ,required Color selectedItemColor ,required Color unSelectedItemColor}){
    return InkWell(
      onTap: onPress,
      child: SizedBox(
        // color:Colors.white,
        width: 20.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset(img,fit: BoxFit.fill,width: 12.w,height: 4.h,color: selected?selectedItemColor:unSelectedItemColor,),
           if(selected)  const SizedBox(
            height:5 ,
          ),
            if(selected) TextNormalWidget(weight:FontWeight.w600,text:title,size:14.sp,color:selected?selectedItemColor:unSelectedItemColor,decoration:TextDecoration.none,decorationColor:Colors.black,maxLines:1)
          ],
        ),
      ),
    );

  }
}
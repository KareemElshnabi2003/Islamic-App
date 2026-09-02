
import 'package:flutter/material.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class DrawerWidget extends StatelessWidget {
  final ThemeData theme;
  final void Function() onPressTimes;
  final void Function() onPressStories;
  final void Function() onPressAzan;
  final void Function() onPressZekr;
  final void Function() onPressTheme;
  final void Function() onPressCompus;
  final void Function(bool) onChangeTheme;
  final void Function() onPressVideos;
  final void Function() onPressDoaa;
  final bool val;
  const DrawerWidget({super.key, required this.theme, required this.onPressTimes, required this.onPressStories, required this.onPressAzan, required this.onPressZekr, required this.onPressTheme, required this.onChangeTheme, required this.val, required this.onPressCompus, required this.onPressVideos, required this.onPressDoaa});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,

      child: Column(
        children: [
          Center(
            child: Image.asset(AppImages.logoImg,width:40.w,height: 30.h,),
          ),
          ListTile(
            onTap: onPressCompus,
            leading:CircleAvatar(
              backgroundImage:AssetImage(AppImages.compusImg),
            ) ,
            trailing: Icon(Icons.arrow_forward_ios,color:theme.iconTheme.color ,size: 17.sp,) ,
            title:              TextNormalWidget(text: "اتجاه القبلة", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ),

          ListTile(
            onTap: onPressTimes,
            leading:CircleAvatar(
              backgroundImage:AssetImage(AppImages.timesImg),
            ) ,
            trailing: Icon(Icons.arrow_forward_ios,color:theme.iconTheme.color ,size: 17.sp,) ,
            title:              TextNormalWidget(text: "التوقيتات", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ),
          ListTile(
            onTap: onPressStories,
            leading:CircleAvatar(
              backgroundImage:AssetImage(AppImages.storiesImg),
            ) ,
            trailing: Icon(Icons.arrow_forward_ios,color:theme.iconTheme.color ,size: 17.sp,) ,
            title:              TextNormalWidget(text: "قصص الانبياء", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ),
          ListTile(
            onTap: onPressAzan,
            leading:CircleAvatar(
              backgroundImage:AssetImage(AppImages.azanImg),
            ) ,
            trailing: Icon(Icons.arrow_forward_ios,color:theme.iconTheme.color ,size: 17.sp,) ,
            title:              TextNormalWidget(text: "الاذان", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ),  ListTile(
            onTap: onPressZekr,
            leading:CircleAvatar(
              backgroundImage:AssetImage(AppImages.zekrImg),
            ) ,
            trailing: Icon(Icons.arrow_forward_ios,color:theme.iconTheme.color ,size: 17.sp,) ,
            title:              TextNormalWidget(text: "اشعار الذكر", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ),
          ListTile(
            onTap: onPressVideos,
            leading:CircleAvatar(
              backgroundImage:AssetImage(AppImages.videoImg),
            ) ,
            trailing: Icon(Icons.arrow_forward_ios,color:theme.iconTheme.color ,size: 17.sp,) ,
            title:              TextNormalWidget(text: "فيديوهات اسلامية", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ),
          ListTile(
            onTap: onPressDoaa,
            leading:CircleAvatar(
              backgroundImage:AssetImage(AppImages.doaaImg),
            ) ,
            trailing: Icon(Icons.arrow_forward_ios,color:theme.iconTheme.color ,size: 17.sp,) ,
            title:              TextNormalWidget(text: "أدعية المسلم", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ),
          ListTile(

            onTap: onPressTheme,
            leading:CircleAvatar(
            child:  Icon(Icons.nightlight_outlined,color:theme.iconTheme.color ,size: 20.sp,) ,
            ) ,
            trailing: Switch(
              value: val,
              onChanged: onChangeTheme,
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,

            ) ,
            title:              TextNormalWidget(text: "الوضع الليلي", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

          ),
        ],
      ),
    );
  }
}

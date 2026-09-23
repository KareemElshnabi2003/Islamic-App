
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
  final void Function()? onPressLogout;
  final bool val;
  const DrawerWidget({
    super.key,
    required this.theme,
    required this.onPressTimes,
    required this.onPressStories,
    required this.onPressAzan,
    required this.onPressZekr,
    required this.onPressTheme,
    required this.onChangeTheme,
    required this.val,
    required this.onPressCompus,
    required this.onPressVideos,
    required this.onPressDoaa,
    this.onPressLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 5.h),
          Center(
            child: Image.asset(AppImages.logoImg, width: 40.w, height: 30.h),
          ),
          _buildDrawerItem(
            title: "اتجاه القبلة",
            iconPath: AppImages.compusImg,
            onTap: onPressCompus,
          ),
          _buildDrawerItem(
            title: "التوقيتات",
            iconPath: AppImages.timesImg,
            onTap: onPressTimes,
          ),
          _buildDrawerItem(
            title: "قصص الانبياء",
            iconPath: AppImages.storiesImg,
            onTap: onPressStories,
          ),
          _buildDrawerItem(
            title: "الاذان",
            iconPath: AppImages.azanImg,
            onTap: onPressAzan,
          ),
          _buildDrawerItem(
            title: "اشعار الذكر",
            iconPath: AppImages.zekrImg,
            onTap: onPressZekr,
          ),
          _buildDrawerItem(
            title: "فيديوهات اسلامية",
            iconPath: AppImages.videoImg,
            onTap: onPressVideos,
          ),
          _buildDrawerItem(
            title: "أدعية المسلم",
            iconPath: AppImages.doaaImg,
            onTap: onPressDoaa,
          ),
          ListTile(
            onTap: onPressTheme,
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.nightlight_outlined, color: theme.iconTheme.color, size: 20.sp),
            ),
            trailing: Switch(
              value: val,
              onChanged: onChangeTheme,
              activeThumbColor: Colors.green,
              inactiveThumbColor: Colors.grey,
            ),
            title: TextNormalWidget(
              text: "الوضع الليلي",
              size: 15.sp,
              color: theme.textTheme.bodyMedium!.color!,
              decoration: TextDecoration.none,
              decorationColor: theme.textTheme.bodyMedium!.color!,
              maxLines: 1,
              weight: FontWeight.bold,
            ),
          ),
          if (onPressLogout != null)
            ListTile(
              onTap: onPressLogout,
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20.sp),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color, size: 17.sp),
              title: TextNormalWidget(
                text: "تسجيل الخروج",
                size: 15.sp,
                color: Colors.redAccent,
                decoration: TextDecoration.none,
                decorationColor: Colors.redAccent,
                maxLines: 1,
                weight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: AssetImage(iconPath),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: theme.iconTheme.color, size: 17.sp),
      title: TextNormalWidget(
        text: title,
        size: 15.sp,
        color: theme.textTheme.bodyMedium!.color!,
        decoration: TextDecoration.none,
        decorationColor: theme.textTheme.bodyMedium!.color!,
        maxLines: 1,
        weight: FontWeight.bold,
      ),
    );
  }
}

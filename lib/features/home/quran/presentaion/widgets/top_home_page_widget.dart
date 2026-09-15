import 'package:flutter/cupertino.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class TopHomePageWidget extends StatelessWidget {
  const TopHomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 40.w,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(AppImages.homeIconImg),fit: BoxFit.fill)),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class TopDoaaWidget extends StatelessWidget {
  const TopDoaaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 60.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(AppImages.doaaImg),fit: BoxFit.cover)),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class TopRadioScreenWidget extends StatelessWidget {
  const TopRadioScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 80.w,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(AppImages.radioIconImg),fit: BoxFit.fill)),
    );
  }
}

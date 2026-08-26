import 'package:flutter/material.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/app_colors.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class QuareWidget extends StatelessWidget {
  final void Function () onPressPlay;
  final void Function () onPressStop;
  final bool play;
  final Map qare;
  final ThemeData theme;


  const QuareWidget({super.key, required this.onPressPlay, required this.onPressStop, required this.play, required this.qare, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: play?onPressStop:onPressPlay ,
      leading:    Container(
        width: 15.w,
        height: 7.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)),image: DecorationImage(image: AssetImage(AppImages.qareTestImg),fit: BoxFit.fill)),
      ),
        title:         TextNormalWidget(text: qare['name'], size: 15.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, decorationColor: theme.textTheme.titleLarge!.color!, maxLines:2, weight: FontWeight.w700),





    trailing:     CircleAvatar(
    backgroundColor:AppColors.primaryLight,

    child: IconButton(onPressed: play?onPressStop:onPressPlay, icon: Icon(play?Icons.stop:Icons.play_arrow,color:play?Colors.green :AppColors.iconLight,size: 15.sp,)))

    );
  }
}

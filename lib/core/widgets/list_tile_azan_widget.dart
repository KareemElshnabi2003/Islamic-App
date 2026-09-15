import 'package:flutter/material.dart';
import 'package:islamic_app/core/theme/app_colors.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class ListTileAzanWidget extends StatelessWidget {
  final ThemeData theme;
  final String name;
  final String img;
  final bool play;
  final void Function() onPressPlay;
  final void Function() onPressStop;
  const ListTileAzanWidget({super.key, required this.theme, required this.name, required this.img, required this.play, required this.onPressPlay, required this.onPressStop});

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(

onTap: play?onPressStop:onPressPlay,        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(        color: theme.dividerColor,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          width: 85.w,
          child: ListTile(


            leading: CircleAvatar(
              backgroundImage: AssetImage(img),
            ),
            trailing:
            CircleAvatar(
                backgroundColor:AppColors.primaryLight,

                child: IconButton(onPressed: play?onPressStop:onPressPlay, icon: Icon(play?Icons.stop:Icons.play_arrow,color:play?Colors.green :AppColors.iconLight,size: 15.sp,),),),


            title: TextNormalWidget(text: name, size: 17.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold) ,


          ),
        ),
      ),
    );
  }
}

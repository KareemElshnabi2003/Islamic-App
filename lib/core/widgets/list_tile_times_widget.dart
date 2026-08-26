import 'package:flutter/material.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class ListTileTimesWidget extends StatelessWidget {
  final ThemeData theme;
  final String time;
  final String trailing;
  final String img;
  const ListTileTimesWidget({super.key, required this.theme, required this.time, required this.trailing, required this.img});

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
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
          TextNormalWidget(text: trailing, size: 17.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold) ,
          title: TextNormalWidget(text: time, size: 17.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold) ,


        ),
      ),
    );
  }
}

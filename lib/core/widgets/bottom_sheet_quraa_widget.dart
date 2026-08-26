import 'package:flutter/material.dart';
import 'package:islamic_app/core/widgets/quare_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';




bottomSheetQuraaWidget({  required ThemeData theme,
     required BuildContext context,
required List listQuraa,
required bool play,
required void Function() onPressPlay,
required void Function() onPressStop}) {
    return showModalBottomSheet(context: context, builder: (context) =>Container(
      height: 40.h,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.dividerColor,borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))),
      child: Column(
        children: [
          TextNormalWidget(text: "الاصوات", size: 17.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, decorationColor: theme.textTheme.titleLarge!.color!, maxLines:1, weight: FontWeight.bold),

          SizedBox(
            width: 100.w,
            height: 30.h,
            child: ListView.separated(itemBuilder: (context, index) =>QuareWidget( theme: theme,qare:  listQuraa[index],onPressPlay: onPressPlay,onPressStop: onPressStop,play: play,) , separatorBuilder: (context, index) =>const SizedBox(height: 15,) , itemCount: listQuraa.length),
          )
        ],
      ),
    ),);
  }


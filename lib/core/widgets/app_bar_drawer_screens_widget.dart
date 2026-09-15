
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class AppBarDrawerScreensWidget extends StatelessWidget {
  final bool back;
  const AppBarDrawerScreensWidget({super.key, required this.back});

  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);
    return SizedBox(
      width: 100.w,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          if (back)    SizedBox(
            width: 20.w,

          ),

          SizedBox(
              width: 60.w,
              child: Center(child: TextNormalWidget(text: "اسلامي", size: 20.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold))),

          if (back)    SizedBox(
            width: 20.w,
            child: IconButton(onPressed: (){
              context.pop();
            }, icon: Icon(Icons.arrow_forward_sharp,color: theme.textTheme.bodyMedium!.color, size: 20.sp,)),
          ),


        ],
      ) ,

    );
  }
}

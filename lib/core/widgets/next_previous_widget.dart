import 'package:flutter/material.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class NextPreviusWidget extends StatelessWidget {
  final void Function()? onPressNext;
  final void Function()? onPressPrev;
  final ThemeData theme;

  const NextPreviusWidget({
    super.key,
    required this.onPressNext,
    required this.onPressPrev,
    required this.theme
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // =======================
        // زرار التالي
        // =======================
        Opacity(
          opacity: onPressNext == null ? 0.3 : 1.0,
          child: IgnorePointer(
            ignoring: onPressNext == null,
            child: InkWell(
              onTap: onPressNext,
              child: Container(
                  margin: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor.withOpacity(.6),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                  width: 30.w,
                  height: 6.h,
                  padding: EdgeInsets.all(3.w),
                  child: TextNormalWidget(
                      text: "التالي",
                      size: 15.sp,
                      color: theme.textTheme.titleLarge!.color!,
                      decoration: TextDecoration.none,
                      decorationColor: theme.textTheme.titleLarge!.color!,
                      maxLines: 1,
                      weight: FontWeight.bold)),
            ),
          ),
        ),

        // =======================
        // زرار السابق
        // =======================
        Opacity(
          // التعديل هنا: فحص onPressPrev بدل onPressNext
          opacity: onPressPrev == null ? 0.3 : 1.0,
          child: IgnorePointer(
            // التعديل هنا: فحص onPressPrev بدل onPressNext
            ignoring: onPressPrev == null,
            child: InkWell(
              onTap: onPressPrev,
              child: Container(
                  margin: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor.withOpacity(.6),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  width: 30.w,
                  height: 6.h,
                  padding: EdgeInsets.all(3.w),
                  child: TextNormalWidget(
                      text: "السابق",
                      size: 15.sp,
                      color: theme.textTheme.titleLarge!.color!,
                      decoration: TextDecoration.none,
                      decorationColor: theme.textTheme.titleLarge!.color!,
                      maxLines: 1,
                      weight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}
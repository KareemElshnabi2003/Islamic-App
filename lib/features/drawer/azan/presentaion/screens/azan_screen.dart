import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/list_tile_azan_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';

class AzanScreen extends StatelessWidget {
  const AzanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme =Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(

        height: 100.h,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(isDarkMode?AppImages.bgDarkImg:AppImages.bgLightImg),fit: BoxFit.fill)
        ),

        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            AppBarDrawerScreensWidget(back: true),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                width: 80.w,
                child: Center(child: TextNormalWidget(text: "الاذان", size: 20.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold))),
            LineWidget(isVertical: false, size: 40.w, color: theme.dividerColor, thick: 2),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                width: 80.w,
                child: Center(child: TextNormalWidget(text: "متبقي علي اذان العصر", size: 18.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold))),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 60.w,
                child: Center(child: TextNormalWidget(text: "05:00:00", size: 22.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold))),



            const SizedBox(
              height: 10,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(

                onTap: (){},
                trailing: Switch(
                  value: true,
                  onChanged: (v){},
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey,

                ) ,
                title:              TextNormalWidget(text: "هل تريد تفعيل اشعار الاذان ؟", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),

              ),
            ),

            const SizedBox(
              height: 20,
            ),
          ListTileAzanWidget(theme: theme, name: "الشيخ تست", img:AppImages.qareTestImg, play: true, onPressPlay: (){}, onPressStop: (){})
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../../../../../core/widgets/line_widget.dart';

class NotifyZekrScreen extends StatelessWidget {
  const NotifyZekrScreen({super.key});

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

        child: SingleChildScrollView(
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
                  child: Center(child: TextNormalWidget(text: "اذكار", size: 20.sp, color: theme. textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme. textTheme.bodyMedium!.color!, maxLines: 1, weight: FontWeight.bold))),
              LineWidget(isVertical: false, size: 40.w, color: theme.dividerColor, thick: 2),
              const SizedBox(
                height: 20,
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
                  title:              TextNormalWidget(text: "هل تريد تفعيل اشعار الذكر ؟", size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),
          
                ),
              ),
          
              Container(
                width: 100.w,
                padding: const EdgeInsets.only(right: 20),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:[
                      TextNormalWidget(text: "التوقيت", size: 20.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),
          
                      LineWidget(isVertical: false, size: 20.w, color: theme.dividerColor, thick: 2),
                    ]),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
          
                children: [
          
                ],
              ),
          
              const SizedBox(
                height: 20,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child:SizedBox(
                  width: 100.w,
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
          
                      itemBuilder: (context, index) =>  RadioListTile(
                    activeColor: Colors.green,
                    groupValue: "times",
                    onChanged: (v){
          
                    },
                    value: times[index],                title:              TextNormalWidget(text:times[index], size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),
                  ), separatorBuilder: (context, index) => const SizedBox(height: 10,), itemCount: times.length),
                )
              ),
          
          
                        Container(
                          width: 100.w,
                          padding: const EdgeInsets.only(right: 20,top: 30),
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:[
                              TextNormalWidget(text: "الاذكار", size: 20.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),
          
                          LineWidget(isVertical: false, size: 20.w, color: theme.dividerColor, thick: 2),
                        ]),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
          
                children: [
          
                ],
              ),
          
              const SizedBox(
                height: 20,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: 100.w,
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => RadioListTile(
                    activeColor: Colors.green,
                    groupValue: "azkar",
                    onChanged: (v){
          
                    },
                    value: azkar[index],                title:              TextNormalWidget(text: azkar[index], size: 15.sp, color: theme.textTheme.bodyMedium!.color!, decoration: TextDecoration.none, decorationColor:theme.textTheme.bodyMedium!.color! , maxLines: 1, weight: FontWeight.bold),
                  ), separatorBuilder:(context, index) => const SizedBox(height: 10,) , itemCount: azkar.length),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

List times=[
  "كل 5 دقائق",
  "كل 10 دقائق",
  "كل 20 دقيقة",
  "كل 30 دقيقة",
  "كل ساعة",
  "كل ساعتين",
];
List azkar=[
  "سبحان الله",
  "الحمد لله",
  "لا اله الا الله",
  "الله اكبر",
];

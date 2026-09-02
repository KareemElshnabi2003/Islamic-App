import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/di/service_locator.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_app_widget.dart';
import 'package:islamic_app/core/widgets/drawer_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/home/radio/presentaion/cubit/radio_cubit.dart';
import 'package:islamic_app/features/home/radio/presentaion/cubit/radio_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

import '../widgets/top_radio_screen_widget.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    ThemeData theme =Theme.of(context);
    return BlocProvider(
  create: (context) => sl<RadioCubit>()..getRadios(),
  child: Scaffold(
      drawer: Drawer(
          child:DrawerWidget(       onPressDoaa: () { context.push(Routes.doaaCatScreen); },
            onPressVideos: () { context.push(Routes.videosTypeScreen); },   onPressCompus:(){context.push(Routes.compusScreen);},val: isDarkMode,theme: theme,onChangeTheme: (v){
            context.read<ThemeCubit>().toggleTheme();
          },onPressAzan: (){
            context.push(Routes.azanSettingScreen);
          },onPressStories: (){            context.push(Routes.storiesScreen);
          },onPressTheme: (){

            context.read<ThemeCubit>().toggleTheme();

          },onPressTimes: (){            context.push(Routes.timesScreen);
          },onPressZekr: (){            context.push(Routes.notifyZekrScreen);
          },)

      ),
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
            AppBarAppWidget(back: false),
            const SizedBox(
              height: 100,
            ),
            BlocBuilder<RadioCubit,RadioState>(
  builder: (context, state) {
    String stationName = "جاري التحميل...";
    bool isLoadingAPI = state is RadioLoading || state is RadioInitial;
    bool isLoadingAudio = false;
    bool isPlaying = false;
    if (state is RadioError) {
      return Expanded(
        child: Center(
          child: TextNormalWidget(
            text: state.message,
            size: 18.sp,
            color: Colors.red,
            decoration: TextDecoration.none,
            decorationColor: Colors.red,
            maxLines: 2,
            weight: FontWeight.bold,
          ),
        ),
      );
    }
    if (state is RadioSuccess){

      if (state.radios.isEmpty) {
        return const Expanded(child: Center(child: Text("لا توجد إذاعات")));
      }
      stationName = state.radios[state.currentIndex].name;
      isLoadingAudio = state.isLoadingAudio;
      isPlaying = state.isPlaying;
    }
      return Column(
        children: [
          TopRadioScreenWidget(),
          const SizedBox(
            height: 15,
          ),

          TextNormalWidget(text:stationName, size: 20.sp, color: theme.textTheme.titleLarge!.color!, decoration: TextDecoration.none, decorationColor: theme.textTheme.titleLarge!.color!, maxLines: 1, weight: FontWeight.w700),
          const SizedBox(
            height: 40,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_next, color: theme.dividerColor, size: 30.sp),
                onPressed: isLoadingAPI
                    ? null
                    : () {
                  context.read<RadioCubit>().nextRadio();
                },
              ),

              IconButton(
                icon: (isLoadingAPI || isLoadingAudio)
                    ? SizedBox(
                  width: 35.sp,
                  height: 35.sp,
                  child: CircularProgressIndicator(
                    color: theme.dividerColor,
                    strokeWidth: 3,
                  ),
                )
                    : Icon(
                  isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_fill,
                  color: theme.dividerColor,
                  size: 35.sp,
                ),
                onPressed: (isLoadingAPI || isLoadingAudio)
                    ? null
                    : () => context.read<RadioCubit>().togglePlay(),
              ),

              IconButton(
                icon: Icon(Icons.skip_previous, color: theme.dividerColor, size: 30.sp),
                onPressed: isLoadingAPI
                    ? null
                    : () {
                  context.read<RadioCubit>().previousRadio();
                },
              ),
            ],
          )

        ],
      );
    }


)
          ],
        ),
      ),
    ),
);
  }
}

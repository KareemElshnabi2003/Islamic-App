import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
    _goToHome();
    super.initState();
  }
 void _goToHome(){
  Timer(const Duration(seconds: 2), ()=>context.go(Routes.homePageScreen));
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);

    return Scaffold(
      backgroundColor:theme.scaffoldBackgroundColor,
      body:Center(
        child: Image.asset(AppImages.logoImg,fit: BoxFit.fill, width: 70.w,height: 30.h,),
      ) ,
    );
  }
}

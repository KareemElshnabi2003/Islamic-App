import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'dart:math' as math;

class CompusScreen extends StatefulWidget {
  const CompusScreen({super.key});

  @override
  State<CompusScreen> createState() => _CompusScreenState();
}

class _CompusScreenState extends State<CompusScreen> {
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();

    _fetchPermissionStatus();
  }
  @override
  Widget build(BuildContext context) {
    final theme =Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body:
      Container(

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
              height: 100,
            ),
            Builder(builder: (context) {
              if (_hasPermissions){
                return _buildCompass();
              }
              else{
                return   _buildPermissionSheet();
              }
            },)

          ],
        ),
      ),
    );
  }


  Widget _buildCompass() {
    return Center(

      child: StreamBuilder<CompassEvent>(

        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error reading heading: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          double? direction = snapshot.data!.heading;

          if (direction == null)
            return Center(
              child: Text("Device does not have sensors !"),
            );

          return  Transform.rotate(

                angle: (direction * (math.pi / 180) * -1),
                child: SizedBox(
                    height: 40.h,
                    width: 80.w,
                    child: Image.asset(AppImages.compusImg,fit: BoxFit.fill,width: 80.w,height: 40.h,)),
              );


        },
      ),
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Location Permission Required'),
          ElevatedButton(
            child: Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }

}


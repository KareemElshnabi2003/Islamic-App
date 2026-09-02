

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:islamic_app/core/network/network_cubit.dart';
import 'package:islamic_app/core/network/network_state.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:screen_go/screen_go.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', "");
  await CacheHelper.init();

  await setupServiceLocator();

  await AndroidAlarmManager.initialize();

  runApp( IslamicApp(initialRoute:Routes.splashScreen ,));
}

class IslamicApp extends StatelessWidget {
  final String initialRoute;
  const IslamicApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenGo(
      materialApp: true,

        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ThemeCubit()),
              BlocProvider(create: (context) => sl<NetworkCubit>()),
            ],
            child: BlocListener<NetworkCubit, NetworkStatus>(
              listener: (context, networkStatus) {
                if (networkStatus == NetworkStatus.disconnected ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'لا يوجد اتصال بالإنترنت. تتصفح الآن البيانات المحفوظة.',
                        style: TextStyle(fontFamily: 'Cairo'), // لو بتستخدم خط عربي
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    title: 'Islamic App',
                    routerConfig: AppRouter.getRouter(initialRoute),
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                  );
                },
              ),
            ),
          );
      },
    );
  }
}

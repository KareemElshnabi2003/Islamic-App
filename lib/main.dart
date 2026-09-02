import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:islamic_app/core/constant/app_audio.dart';
import 'package:islamic_app/core/network/network_cubit.dart';
import 'package:islamic_app/core/network/network_state.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_cubit.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_state.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/screens/azan_audio_screen.dart';
import 'package:screen_go/screen_go.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/di/service_locator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', "");
  await CacheHelper.init();
  await setupServiceLocator();
  await AndroidAlarmManager.initialize();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload == 'adhan_payload') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => AdhanAudioScreen(
              selectedSheikhAudio: AppAudio.abdelbaset,
              prayerName: "الصلاة",
            ),
          ),
        );
      }
    },
  );

  final notificationDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationDetails != null && notificationDetails.didNotificationLaunchApp) {
    if (notificationDetails.notificationResponse?.payload == 'adhan_payload') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => AdhanAudioScreen(
              selectedSheikhAudio: AppAudio.abdelbaset,
              prayerName: "الصلاة",
            ),
          ),
        );
      });
    }
  }

  runApp(const IslamicApp(initialRoute: Routes.splashScreen));
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
            BlocProvider(create: (context) => sl<AdhanTimerCubit>()..initTimer()),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<NetworkCubit, NetworkStatus>(
                listener: (context, networkStatus) {
                  if (networkStatus == NetworkStatus.disconnected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'لا يوجد اتصال بالإنترنت. تتصفح الآن البيانات المحفوظة.',
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
              BlocListener<AdhanTimerCubit, AdhanTimerState>(
                listener: (context, state) {
                  if (state is AdhanTimeArrived) {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => AdhanAudioScreen(
                          selectedSheikhAudio: CacheHelper.getData(key: 'AZAN_AUDIO_PATH') ?? AppAudio.abdelbaset,
                          prayerName: state.prayerName,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
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
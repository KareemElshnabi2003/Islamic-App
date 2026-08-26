

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/drawer/azan/presentaion/screens/azan_screen.dart';
import '../../features/drawer/compus/presentaion/screens/compus_screen.dart';
import '../../features/drawer/stories/presentaion/screens/stories_screen.dart';
import '../../features/drawer/stories/presentaion/screens/story_info_screen.dart';
import '../../features/drawer/times/presentaion/screens/times_screen.dart';
import '../../features/drawer/zekr/presentaion/screens/notify_zekr_screen.dart';
import '../../features/home/ahadeth/presentaion/screens/ahadeth_screen.dart';
import '../../features/home/ahadeth/presentaion/screens/hadeth_screen.dart';
import '../../features/home/azkar/presentaion/screens/azkar_screen.dart';
import '../../features/home/quran/presentaion/screens/home_page_screen.dart';
import '../../features/home/quran/presentaion/screens/soura_screen.dart';
import '../../features/home/radio/presentaion/screens/radio_screen.dart';
import '../../features/main/presentaion/screens/main_layout_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter getRouter(String initialLocation) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      routes: [
        // --- مسارات المصادقة والبداية (كما هي بدون تغيير) ---
        GoRoute(
          path: Routes.splashScreen,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: Routes.souraScreen,
          builder: (context, state) => SouraScreen(),
        ),
        GoRoute(
          path: Routes.hadethScreen,
          builder: (context, state) => HadethScreen(),
        ),

        GoRoute(
          path: Routes.timesScreen,
          builder: (context, state) => TimesScreen(),
        ),
        GoRoute(
          path: Routes.storiesScreen,
          builder: (context, state) => StoriesScreen(),
        ),
        GoRoute(
          path: Routes.storyInfoScreen,
          builder: (context, state) => StoryInfoScreen(),
        ),
        GoRoute(
          path: Routes.azanScreen,
          builder: (context, state) => AzanScreen(),
        ),
        GoRoute(
          path: Routes.notifyZekrScreen,
          builder: (context, state) => NotifyZekrScreen(),
        ),
        GoRoute(
          path: Routes.compusScreen,
          builder: (context, state) => CompusScreen(),
        ),
        // --- التعديل الجذري هنا ---
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return  MainLayoutScreen(navigationShell: navigationShell
            );
          },
          branches: [

            //item 1
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.homePageScreen,
                  builder: (context, state) => HomePageScreen(),
                ),

              ],
            ),
            // item2
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.ahadethScreen,
                  builder: (context, state) => AhadethScreen(),
                ),

              ],
            ),
            //item 3
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.azkarScreen,
                  builder: (context, state) => AzkarScreen(),
                ),

              ],
            ),
            //item 4
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.radioScreen,
                  builder: (context, state) => RadioScreen(),
                ),

              ],
            ),


          ],
        ),

      ],
    );


  }
}
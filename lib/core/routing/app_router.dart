import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/di/service_locator.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/doaa_cubit.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/cubit/oaa_reader_cubit.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/screens/doaa_cat_screen.dart';
import 'package:islamic_app/features/drawer/doaa/presentaion/screens/doaa_screen.dart';
import 'package:islamic_app/features/drawer/stories/presentaion/screens/stories_screen.dart';
import 'package:islamic_app/features/drawer/stories/presentaion/screens/story_info_screen.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/single_video_entity.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/cubit/video_cubit.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/cubit/video_player_cubit.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/screens/video_type_screen.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/screens/videos_screen.dart';
import 'package:islamic_app/features/drawer/zekr/presentaion/cubit/zekr_notify_cubit.dart';


import '../../features/drawer/azan/presentaion/screens/azan_screen.dart';
import '../../features/drawer/compus/presentaion/screens/compus_screen.dart';
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

import '../../features/drawer/stories/presentaion/cubit/story_cubit.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter getRouter(String initialLocation) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: Routes.splashScreen,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: Routes.souraScreen,
          builder: (context, state) {
            final suraId = state.extra as int;
            return SouraScreen(suraId: suraId,);
          },
        ),
        GoRoute(
          path: Routes.doaaCatScreen, // تأكد إن الاسم ده موجود في ملف Routes
          builder: (context, state) {
            return BlocProvider<DoaaCubit>(
              create: (context) => sl<DoaaCubit>()..getAllCategoriesWithDuas(),
              child: const DoaaCatScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.doaaDetailsScreen,
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            final duas = args['duas'];
            final title = args['title'];

            return BlocProvider<DoaaReaderCubit>(
              create: (context) => sl<DoaaReaderCubit>()..init(duas),
              child: DoaaDetailsScreen(title: title),
            );
          },
        ),

        GoRoute(
          path: Routes.notifyZekrScreen,
          builder: (context, state) => BlocProvider<ZekrNotificationCubit>(
            create: (context) => sl<ZekrNotificationCubit>()..loadSettings(),
            child: const NotifyZekrScreen(),
          ),
        ),
        GoRoute(
          path: Routes.videosTypeScreen,
          builder: (context, state) {
            return BlocProvider<VideoCubit>(
              create: (context) => sl<VideoCubit>()..getVideos(),
              child: const VideoTypeScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.videosScreen,
          builder: (context, state) {
            final videos = (state.extra as List<SingleVideoEntity>?) ?? [];
            return BlocProvider<VideoPlayerCubit>(
              create: (context) => sl<VideoPlayerCubit>()..init(videos),
              child: const VideosScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.hadethScreen,
          builder: (context, state) {
            final authorKey = state.extra as String;
            return HadethScreen(authorKey: authorKey);
          },
        ),
        GoRoute(
          path: Routes.timesScreen,
          builder: (context, state) => TimesScreen(),
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

        ShellRoute(
          builder: (context, state, child) {
            return BlocProvider<StoriesCubit>(
              create: (context) => sl<StoriesCubit>()..getStories(),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: Routes.storiesScreen,
              builder: (context, state) => const StoriesScreen(),
            ),
            GoRoute(
              path: Routes.storyInfoScreen,
              builder: (context, state) => const StoryInfoScreen(),
            ),
          ],
        ),
        // -------------------------------------------------------------------------

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainLayoutScreen(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.homePageScreen,
                  builder: (context, state) => HomePageScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.ahadethScreen,
                  builder: (context, state) => AhadethScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: Routes.azkarScreen,
                  builder: (context, state) => AzkarScreen(),
                ),
              ],
            ),
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
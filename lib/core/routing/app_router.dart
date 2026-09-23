import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/di/service_locator.dart';
import 'package:islamic_app/features/drawer/azan/presentation/screens/azan_audio_screen.dart';
import 'package:islamic_app/features/drawer/doaa/presentation/cubit/doaa_cubit.dart';
import 'package:islamic_app/features/drawer/doaa/presentation/cubit/doaa_reader_cubit.dart';
import 'package:islamic_app/features/drawer/doaa/presentation/screens/doaa_cat_screen.dart';
import 'package:islamic_app/features/drawer/doaa/presentation/screens/doaa_screen.dart';
import 'package:islamic_app/features/drawer/stories/presentation/screens/stories_screen.dart';
import 'package:islamic_app/features/drawer/stories/presentation/screens/story_info_screen.dart';
import 'package:islamic_app/features/drawer/videos/domain/entities/single_video_entity.dart';
import 'package:islamic_app/features/drawer/videos/presentation/cubit/video_cubit.dart';
import 'package:islamic_app/features/drawer/videos/presentation/cubit/video_player_cubit.dart';
import 'package:islamic_app/features/drawer/videos/presentation/screens/video_type_screen.dart';
import 'package:islamic_app/features/drawer/videos/presentation/screens/videos_screen.dart';
import 'package:islamic_app/features/drawer/zekr/presentation/cubit/zekr_notify_cubit.dart';

import 'package:islamic_app/features/drawer/azan/presentation/screens/azan_screen.dart';
import 'package:islamic_app/features/drawer/compus/presentation/screens/compus_screen.dart';
import 'package:islamic_app/features/drawer/times/presentation/screens/times_screen.dart';
import 'package:islamic_app/features/drawer/zekr/presentation/screens/notify_zekr_screen.dart';
import 'package:islamic_app/features/home/ahadeth/presentation/screens/ahadeth_screen.dart';
import 'package:islamic_app/features/home/ahadeth/presentation/screens/hadeth_screen.dart';
import 'package:islamic_app/features/home/azkar/presentation/screens/azkar_screen.dart';
import 'package:islamic_app/features/home/quran/presentation/screens/home_page_screen.dart';
import 'package:islamic_app/features/home/quran/presentation/screens/soura_screen.dart';
import 'package:islamic_app/features/home/radio/presentation/screens/radio_screen.dart';
import 'package:islamic_app/features/main/presentation/screens/main_layout_screen.dart';
import 'package:islamic_app/features/splash/splash_screen.dart';
import 'package:islamic_app/features/drawer/stories/presentation/cubit/story_cubit.dart';
import 'package:islamic_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:islamic_app/features/auth/presentation/screens/login_screen.dart';
import 'package:islamic_app/features/auth/presentation/screens/verify_code_screen.dart';
import 'routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static GoRouter? _router;

  static GoRouter getRouter(String initialLocation) {
    return _router ??= _createRouter(initialLocation);
  }

  static GoRouter _createRouter(String initialLocation) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: Routes.splashScreen,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: Routes.loginScreen,
          builder: (context, state) => BlocProvider<AuthCubit>(
            create: (context) => sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: Routes.verifyCodeScreen,
          builder: (context, state) {
            final args = (state.extra as Map<String, dynamic>?) ?? {};
            final verificationId = args['verificationId'] as String? ?? "";
            final phoneNumber = args['phoneNumber'] as String? ?? "";
            return BlocProvider<AuthCubit>(
              create: (context) => sl<AuthCubit>(),
              child: VerifyCodeScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.souraScreen,
          builder: (context, state) {
            final suraId = state.extra as int;
            return SouraScreen(suraId: suraId,);
          },
        ),
        GoRoute(
          path: Routes.doaaCatScreen,
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
          path: Routes.azanAudioScreen,
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            return AdhanAudioScreen(
              prayerName: args['prayerName'] as String,
              selectedSheikhAudio: args['selectedSheikhAudio'] as String,
            );
          },
        ),

        GoRoute(
          path: Routes.azanSettingScreen,
          builder: (context, state) {
            return AdhanSettingsScreen();
          },
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/core/widgets/next_previous_widget.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/cubit/video_player_cubit.dart';
import 'package:islamic_app/features/drawer/videos/presentaion/cubit/video_player_state.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/widgets/line_widget.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  String _getTypeVideoName(int idType) {
    return idType == 2
        ? "الصلاة على النبي صلى الله عليه وسلم"
        : idType == 4 ? "نفحات رمضانية" : "نفحات إيمانية";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    final playerCubit = context.read<VideoPlayerCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        height: 100.h,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            const SizedBox(height: 40),
            AppBarDrawerScreensWidget(back: true),
            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
                builder: (context, state) {
                  if (playerCubit.videos.isEmpty) return const SizedBox();

                  final video = playerCubit.videos[state.currentIndex];
                  final typeName = _getTypeVideoName(video.type);

                  // =====================================
                  // تحديد هل فيه فيديو تالي وسابق ولا لأ
                  // =====================================
                  final bool hasNext = state.currentIndex < playerCubit.videos.length - 1;
                  final bool hasPrev = state.currentIndex > 0;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                              color: theme.scaffoldBackgroundColor.withOpacity(.6),
                              borderRadius: BorderRadius.circular(25)),
                          width: 90.w,
                          padding: EdgeInsets.all(3.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextNormalWidget(
                                      text: typeName,
                                      size: 17.sp,
                                      color: theme.textTheme.titleLarge!.color!,
                                      decoration: TextDecoration.none,
                                      decorationColor: theme.textTheme.titleLarge!.color!,
                                      maxLines: 1,
                                      weight: FontWeight.w700),
                                  const SizedBox(width: 15),
                                ],
                              ),
                              LineWidget(isVertical: false, size: 70.w, color: theme.dividerColor, thick: 2),
                              const SizedBox(height: 20),

                              Container(
                                height: 25.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.black12,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: state.isLoading
                                    ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network(video.img, fit: BoxFit.cover, width: double.infinity),
                                    const CircularProgressIndicator(color: Colors.white),
                                  ],
                                )
                                    : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (playerCubit.videoService.controller != null &&
                                        playerCubit.videoService.controller!.value.isInitialized)
                                      AspectRatio(
                                        aspectRatio: playerCubit.videoService.controller!.value.aspectRatio,
                                        child: VideoPlayer(playerCubit.videoService.controller!),
                                      )
                                    else
                                      Image.network(video.img, fit: BoxFit.cover, width: double.infinity),

                                    GestureDetector(
                                      onTap: playerCubit.togglePlay,
                                      child: Container(
                                        color: state.isPlaying ? Colors.transparent : Colors.black45,
                                        child: Center(
                                          child: state.isPlaying
                                              ? const SizedBox()
                                              : Icon(Icons.play_circle_filled, size: 45.sp, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // =====================================
                        // إرسال null لو مفيش فيديو في الاتجاه ده
                        // =====================================
                        NextPreviusWidget(
                          onPressNext: hasNext ? playerCubit.nextVideo : null,
                          onPressPrev: hasPrev ? playerCubit.prevVideo : null,
                          theme: theme,
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
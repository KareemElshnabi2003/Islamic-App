import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/widgets/text_normal_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/ayat_cubit.dart';
import 'package:islamic_app/features/home/quran/presentaion/cubit/ayat_state.dart';

void bottomSheetQuraaWidget({
  required BuildContext context,
  required ThemeData theme,
}) {
  final cubit = context.read<AyatCubit>();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) {
      return BlocProvider.value(
        value: cubit,
        child: BlocBuilder<AyatCubit, AyatState>(
          builder: (context, state) {
            if (state is AyatSuccess) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFC49F63),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                padding: EdgeInsets.all(5.w),
                child: Column(
                  children: [
                    TextNormalWidget(
                      decorationColor: Colors.black,
                      text: "الاصوات",
                      size: 20.sp,
                      color: Colors.black,
                      weight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.ayat.audio.length,
                        itemBuilder: (context, index) {
                          final qari = state.ayat.audio[index];

                          bool isThisItemPlaying = state.isPlaying && state.selectedQariIndex == index;

                          return InkWell(
                            onTap: () {
                              if (isThisItemPlaying) {
                                cubit.togglePlay();
                              } else {
                                cubit.changeQari(index);
                                cubit.togglePlay();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.black12,
                                        child: Icon(Icons.headset_mic, color: Colors.black, size: 22.sp),
                                      ),
                                      SizedBox(width: 4.w),
                                      SizedBox(
                                        width: 50.w,
                                        child: TextNormalWidget(
                                          decorationColor:Colors.black ,
                                          text: qari.qare,
                                          size: 16.sp,
                                          color: Colors.black,
                                          weight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // زرار التشغيل والإيقاف لكل عنصر
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 18,
                                    child: Icon(
                                      isThisItemPlaying ? Icons.stop : Icons.play_arrow,
                                      color: isThisItemPlaying ? Colors.red : Colors.green,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      );
    },
  );
}
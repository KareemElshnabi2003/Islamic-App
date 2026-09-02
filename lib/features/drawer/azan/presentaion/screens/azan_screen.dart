import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:islamic_app/core/constant/app_audio.dart';
import 'package:islamic_app/core/constant/app_images.dart';
import 'package:islamic_app/core/routing/routes.dart';
import 'package:islamic_app/core/theme/theme_cubit.dart';
import 'package:islamic_app/core/widgets/app_bar_drawer_screens_widget.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_cubit.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_state.dart';

class AdhanSettingsScreen extends StatelessWidget {
  AdhanSettingsScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> sheikhsList = [
    {'name': 'الشيخ عبد الباسط', 'path': AppAudio.abdelbaset},
    {'name': 'الشيخ أحمد الكردي', 'path': AppAudio.elkordy},
    {'name': 'الشيخ الدوسري', 'path': AppAudio.eldosary},
    {'name': 'الشيخ الحصري', 'path': AppAudio.elhosary},
    {'name': 'الشيخ المنشاوي', 'path': AppAudio.elmenshawy},
    {'name': 'الشيخ هشام خليل', 'path': AppAudio.khalil},
    {'name': 'الشيخ سامر الصغير', 'path': AppAudio.elsogier},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<AdhanTimerCubit, AdhanTimerState>(
        listener: (context, state) {
          if (state is AdhanTimeArrived) {
            context.push(
              Routes.azanAudioScreen,
              extra: {
                'prayerName': state.prayerName,
                'selectedSheikhAudio': state.audioPath,
              },
            );
            context.read<AdhanTimerCubit>().initTimer();
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(isDarkMode ? AppImages.bgDarkImg : AppImages.bgLightImg),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                const SizedBox(height: 50),
                AppBarDrawerScreensWidget(back: true),
                const SizedBox(height: 40),

                BlocBuilder<AdhanTimerCubit, AdhanTimerState>(
                  builder: (context, state) {
                    if (state is AdhanTimerLoading) {
                      return const Expanded(
                        child: Center(child: CircularProgressIndicator(color: Color(0xFFB5935A))),
                      );
                    }

                    if (state is AdhanTimerError) {
                      return Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "عذراً.. ${state.message}\nبرجاء فتح شاشة مواقيت الصلاة لتحديث البيانات",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                            ),
                          ),
                        ),
                      );
                    }

                    String prayerName = "---";
                    String timeRemaining = "00:00:00";
                    String currentSheikhName = context.read<AdhanTimerCubit>().selectedAudioName;
                    bool isAlarmActive = context.read<AdhanTimerCubit>().isAlarmEnabled; // 👈 قراءة حالة السويتش

                    if (state is AdhanTimerTicking) {
                      prayerName = state.nextPrayerName;
                      timeRemaining = state.timeRemaining;
                      currentSheikhName = state.selectedAudioName;
                      isAlarmActive = state.isAlarmEnabled; // 👈 تحديث السويتش من الكيوبيت
                    }

                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("متبقي علي اذان $prayerName", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 15),
                          Text(
                              timeRemaining,
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w500, color: Colors.black, letterSpacing: 2.0)
                          ),
                          const SizedBox(height: 40),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("هل تريد تفعيل اشعار الاذان ؟", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                // 👇 السويتش أصبح تفاعلي وبيكلم الكيوبيت
                                CupertinoSwitch(
                                  value: isAlarmActive,
                                  activeColor: Colors.green,
                                  onChanged: (bool value) {
                                    context.read<AdhanTimerCubit>().toggleAlarm(value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          InkWell(
                            onTap: () => _showSheikhSelection(context),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20.0),
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                              decoration: BoxDecoration(color: const Color(0xFFB5935A), borderRadius: BorderRadius.circular(25)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white24,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  Text(currentSheikhName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSheikhSelection(BuildContext context) {
    // 👈 السحر هنا: بنحفظ الكيوبيت في متغير قبل ما الـ Context يضيع جوه الـ BottomSheet
    final cubit = context.read<AdhanTimerCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext bottomSheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const Text("اختر المؤذن", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: sheikhsList.length,
                    itemBuilder: (context, index) {
                      final sheikh = sheikhsList[index];
                      return ListTile(
                        leading: const Icon(Icons.person, color: Color(0xFFB5935A)),
                        title: Text(sheikh['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        onTap: () {
                          cubit.changeSheikh(sheikh['name']!, sheikh['path']!);
                          bottomSheetContext.pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
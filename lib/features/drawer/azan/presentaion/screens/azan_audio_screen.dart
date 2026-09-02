import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// تأكد من مسارات الكيوبيت عندك
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_audio_cubit.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_audio_state.dart';

class AdhanAudioScreen extends StatelessWidget {
  final String prayerName;
  final String selectedSheikhAudio;

  // 🔴 تأكد إن المسارات دي صحيحة وموجودة في pubspec.yaml
  final List<String> azanImages = [
    'assets/images/azan1.webp',
    'assets/images/azan2.webp',
    'assets/images/azan3.webp',
  ];

  AdhanAudioScreen({
    Key? key,
    required this.prayerName,
    required this.selectedSheikhAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdhanAudioCubit()
        ..playAdhan(selectedSheikhAudio, () {
          if (context.canPop()) {
            context.pop();
          }
        }),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<AdhanAudioCubit, AdhanAudioState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // ==========================================
                // 1. الأنيميشن (التداخل والزووم)
                // ==========================================
                AnimatedSwitcher(
                  duration: const Duration(seconds: 2), // وقت التداخل بين الصورتين
                  // 👇 ده اللي هيعمل تأثير الـ Fade كأنها لقطة سينمائية
                  transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                  child: Container(
                    // 👇 الـ Key ده هو اللي بيخلي الفلاتر يفهم إن الصورة اتغيرت ويبدأ يدمجهم
                    key: ValueKey<int>(state.currentImageIndex),
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 1.0, end: 1.4), // كبرنا الزووم عشان الحركة تبان بوضوح
                      duration: const Duration(seconds: 8), // الزووم بياخد 8 ثواني
                      builder: (context, double scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Image.asset(
                            azanImages[state.currentImageIndex],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ==========================================
                // 2. الظل عشان الكلام يبقى واضح
                // ==========================================
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),

                // ==========================================
                // 3. النصوص والأيقونة
                // ==========================================
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mosque_rounded, size: 70, color: Colors.amberAccent),
                    const SizedBox(height: 20),
                    Text(
                      "حان الآن موعد أذان\n$prayerName",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.5,
                        shadows: [Shadow(blurRadius: 15, color: Colors.black87)],
                      ),
                    ),
                  ],
                ),

                // ==========================================
                // 4. زرار الإيقاف
                // ==========================================
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.white30, width: 1),
                        ),
                      ),
                      onPressed: () {
                        context.read<AdhanAudioCubit>().stopAdhan();
                        context.pop();
                      },
                      icon: const Icon(Icons.volume_off_rounded, color: Colors.white70),
                      label: const Text("إيقاف الأذان", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
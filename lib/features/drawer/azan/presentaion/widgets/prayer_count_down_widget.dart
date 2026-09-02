import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_cubit.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/cubit/azan_state.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/screens/azan_audio_screen.dart';
import 'package:islamic_app/features/drawer/azan/presentaion/screens/azan_screen.dart';

class PrayerCountdownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdhanTimerCubit, AdhanTimerState>(
      listener: (context, state) {
        if (state is AdhanTimeArrived) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdhanAudioScreen(
                prayerName: state.prayerName,
                selectedSheikhAudio: 'assets/audios/adhan_makkah.mp3',
              ),
            ),
          );
          context.read<AdhanTimerCubit>().initTimer();
        }
      },
      builder: (context, state) {
        if (state is AdhanTimerLoading) {
          return const CircularProgressIndicator();
        } else if (state is AdhanTimerTicking) {
          return Column(
            children: [
              Text("متبقي على صلاة ${state.nextPrayerName}"),
              Text(
                state.timeRemaining,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ],
          );
        } else if (state is AdhanTimerError) {
          return Text(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
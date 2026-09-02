abstract class AdhanTimerState {}

class AdhanTimerInitial extends AdhanTimerState {}

class AdhanTimerLoading extends AdhanTimerState {}

class AdhanTimerError extends AdhanTimerState {
  final String message;
  AdhanTimerError(this.message);
}

class AdhanTimerTicking extends AdhanTimerState {
  final String nextPrayerName;
  final String timeRemaining;
  final String selectedAudioName;
  final bool isAlarmEnabled; // 👈 ضفنا حالة السويتش هنا

  AdhanTimerTicking({
    required this.nextPrayerName,
    required this.timeRemaining,
    required this.selectedAudioName,
    required this.isAlarmEnabled, // 👈 متنساش دي
  });
}

class AdhanTimeArrived extends AdhanTimerState {
  final String prayerName;
  final String audioPath;

  AdhanTimeArrived({
    required this.prayerName,
    required this.audioPath,
  });
}
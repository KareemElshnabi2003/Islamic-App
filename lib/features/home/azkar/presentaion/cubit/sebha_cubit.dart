import 'package:flutter_bloc/flutter_bloc.dart';
import 'sebha_state.dart';

class SebhaCubit extends Cubit<SebhaState> {
  SebhaCubit() : super(SebhaState());

  final List<String> azkar = [
    "سبحان الله",
    "الحمد لله",
    "لا اله الا الله",
    "الله اكبر"
  ];

  void increment() {
    int newCounter = state.counter + 1;
    int newZekrIndex = state.zekrIndex;

    // الدوران: بنزود الزاوية مع كل ضغطة
    double newAngle = state.rotationAngle + 0.2;

    // لو العداد وصل 33، نصفر وننقل على الذكر اللي بعده
    if (newCounter > 33) {
      newCounter = 1;
      newZekrIndex = (newZekrIndex + 1) % azkar.length;
    }

    emit(state.copyWith(
      counter: newCounter,
      zekrIndex: newZekrIndex,
      rotationAngle: newAngle,
    ));
  }
}
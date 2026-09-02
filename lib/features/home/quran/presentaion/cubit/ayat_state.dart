// ================= State =================
import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/home/quran/domain/entities/ayat_entity.dart';

abstract class AyatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AyatInitial extends AyatState {}
class AyatLoading extends AyatState {}

class AyatSuccess extends AyatState {
  final AyatEntity ayat;
  final int currentSurahId;
  final bool isPlaying;
  final int selectedQariIndex; // عشان نحدد القارئ اللي تم اختياره من BottomSheet

  AyatSuccess({
    required this.ayat,
    required this.currentSurahId,
    this.isPlaying = false,
    this.selectedQariIndex = 0, // افتراضياً القارئ الأول
  });

  AyatSuccess copyWith({
    AyatEntity? ayat,
    int? currentSurahId,
    bool? isPlaying,
    int? selectedQariIndex,
  }) {
    return AyatSuccess(
      ayat: ayat ?? this.ayat,
      currentSurahId: currentSurahId ?? this.currentSurahId,
      isPlaying: isPlaying ?? this.isPlaying,
      selectedQariIndex: selectedQariIndex ?? this.selectedQariIndex,
    );
  }

  @override
  List<Object?> get props => [ayat, currentSurahId, isPlaying, selectedQariIndex];
}

class AyatError extends AyatState {
  final String message;
  AyatError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/home/radio/domain/entities/radio_entity.dart';

abstract class RadioState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RadioInitial extends RadioState {

}

class RadioLoading extends RadioState {

}

class RadioSuccess extends RadioState {
  final List<RadioEntity> radios;
  final int currentIndex;
  final bool isPlaying;
  final bool isLoadingAudio;

  RadioSuccess({
    required this.radios,
    this.currentIndex = 0,
    this.isPlaying = false,
    this.isLoadingAudio = false,
  });

  RadioSuccess copyWith({
    List<RadioEntity>? radios,
    int? currentIndex,
    bool? isPlaying,
    bool? isLoadingAudio,
  }) {
    return RadioSuccess(
      radios: radios ?? this.radios,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoadingAudio: isLoadingAudio ?? this.isLoadingAudio,
    );
  }
  @override
  List<Object?> get props => [radios, currentIndex, isPlaying, isLoadingAudio];
}

class RadioError extends RadioState {
  final String message;
  RadioError({required this.message});

  @override
  List<Object?> get props => [message];
}
import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';

abstract class TimesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TimesInitial extends TimesState {}

class TimesLoading extends TimesState {}

class TimesSuccess extends TimesState {
  final TimesEntity times;
  final String cityName;
  final String gregorianDate;
  final String hijriDate;

  TimesSuccess({
    required this.times,
    required this.cityName,
    required this.gregorianDate,
    required this.hijriDate,
  });

  @override
  List<Object?> get props => [times, cityName, gregorianDate, hijriDate];
}

class TimesError extends TimesState {
  final String message;
  TimesError({required this.message});

  @override
  List<Object?> get props => [message];
}
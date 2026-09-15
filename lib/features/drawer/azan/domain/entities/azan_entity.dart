import 'package:equatable/equatable.dart';

class TimesEntity extends Equatable {
  final String fajr;
  final String sunrise;
  final String duhr;
  final String asr;
  final String sunset;
  final String magreb;
  final String isha;
  final String imsak;
  final String midnight;
  final String firstthird;
  final String lastthird;

  const TimesEntity({
    required this.fajr,
    required this.sunrise,
    required this.duhr,
    required this.asr,
    required this.sunset,
    required this.magreb,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstthird,
    required this.lastthird,
  });

  @override
  List<Object?> get props => [
    fajr, sunrise, duhr, asr, sunset, magreb, isha, imsak, midnight, firstthird, lastthird
  ];
}
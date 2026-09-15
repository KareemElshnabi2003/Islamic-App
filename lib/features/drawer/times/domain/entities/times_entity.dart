import 'package:equatable/equatable.dart';


// "data": {
// "timings": {
// "Fajr": "06:03",
// "Sunrise": "08:06",


// "Dhuhr": "12:04",
// "Asr": "13:45",
// "Sunset": "16:03",
// "Maghrib": "16:03",
// "Isha": "17:59",
// "Imsak": "05:53",
// "Midnight": "00:04",
// "Firstthird": "21:24",
// "Lastthird": "02:45"
// },


class TimesEntity  extends Equatable{
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

const TimesEntity({required this.fajr,required this.sunrise,required this.duhr,required this.asr,required this.sunset,required this.magreb,required this.isha,required this.imsak,required this.midnight,required this.firstthird,required this.lastthird});
  @override
  List<Object?> get props => [fajr,sunrise,duhr,asr,sunset,magreb,isha,imsak,midnight,firstthird,lastthird];


}
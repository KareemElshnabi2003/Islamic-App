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

import 'package:islamic_app/features/drawer/times/domain/entities/times_entity.dart';

class TimesModel extends TimesEntity{
 const  TimesModel({required super.asr,required super.duhr,required super.fajr,required, required super.sunrise, required super.sunset, required super.magreb, required super.isha, required super.imsak, required super.midnight, required super.firstthird, required super.lastthird});

factory TimesModel.fromJson(Map<String,dynamic> json){

  return TimesModel(asr: json['Asr'],
duhr:json['Dhuhr'],
fajr: json['Fajr'],
sunrise: json['Sunrise'],
sunset: json['Sunset'],
magreb: json['Maghrib'],
isha: json['Isha'],
imsak: json['Imsak'],
midnight:json['Midnight'],
firstthird: json['Firstthird'],
lastthird: json['Lastthird']);
}

Map<String,dynamic> toJson(){

  return {
"Fajr":fajr ,
"Sunrise":sunrise,
"Dhuhr":duhr ,
"Asr":asr,
"Sunset":sunset,
"Maghrib": magreb,
"Isha": isha,
"Imsak":imsak,
"Midnight": midnight,
"Firstthird": firstthird,
"Lastthird":lastthird
};
}

}
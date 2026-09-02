// "data": {
// "surah": {
// "number": 1,
// "name_arabic": "الفاتحة",
// },
// "audio": [
// {
// "reciter_id": 1,
// "reciter": "Mishary Rashid Alafasy",
// "surah_audio": "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/001.mp3"
// }
//
// ],
// "total_verses": 7,
// "verses": [
// {
// "ayah": 1,
// "arabic": "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
// },
// ]
// }

import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/home/quran/domain/entities/audio_soura_entity.dart';
import 'package:islamic_app/features/home/quran/domain/entities/sura_entity.dart';
import 'package:islamic_app/features/home/quran/domain/entities/varses_entity.dart';

class AyatEntity  extends Equatable{
  final SuraEntity sura;
  final List< AudioSouraEntity> audio;
  final List <VarsesEntity> varses;
  final int totalVarses;
  const AyatEntity({required this.sura,required this.audio,required this.varses,required this.totalVarses});

  @override
  List<Object?> get props => [sura,audio,varses,totalVarses];

}
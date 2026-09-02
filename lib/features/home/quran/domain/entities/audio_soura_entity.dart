// {
// "reciter_id": 1,
// "reciter": "Mishary Rashid Alafasy",
// "surah_audio": "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/001.mp3"
// }

import 'package:equatable/equatable.dart';

class AudioSouraEntity  extends Equatable{
  final int id;
  final  String qare;
  final String audioUrl;
  const AudioSouraEntity({required this.id,required this.qare,required this.audioUrl});

  @override
  List<Object?> get props => [id,qare,audioUrl];


}
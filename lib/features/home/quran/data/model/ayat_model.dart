import 'package:islamic_app/features/home/quran/data/model/audio_soura_model.dart';
import 'package:islamic_app/features/home/quran/data/model/sura_model.dart';
import 'package:islamic_app/features/home/quran/data/model/varses_model.dart';
import 'package:islamic_app/features/home/quran/domain/entities/ayat_entity.dart';

class AyatModel extends AyatEntity {
  const AyatModel({
    required super.sura,
    required super.audio,
    required super.varses,
    required super.totalVarses
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) {
    return AyatModel(
      sura: SuraModel.fromJson(json['surah'] ?? {}),

      audio: json['audio'] != null
          ? (json['audio'] as List).map((e) => AudioSouraModel.fromJson(e)).toList()
          : [],

      varses: json['verses'] != null
          ? (json['verses'] as List).map((e) => VarsesModel.fromJson(e)).toList()
          : [],

      totalVarses: json['total_verses'] ?? 0, // 💡 مكانها المظبوط في الداتا
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "surah": (sura as SuraModel).toJson(),
      "audio": audio.map((e) => (e as AudioSouraModel).toJson()).toList(),
      "verses": varses.map((e) => (e as VarsesModel).toJson()).toList(),
      'total_verses': totalVarses
    };
  }
}
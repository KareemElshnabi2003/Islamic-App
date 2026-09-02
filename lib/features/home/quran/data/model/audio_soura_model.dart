import 'package:islamic_app/features/home/quran/domain/entities/audio_soura_entity.dart';

class AudioSouraModel extends AudioSouraEntity {
  const AudioSouraModel({required super.id, required super.qare, required super.audioUrl});

  factory AudioSouraModel.fromJson(Map<String, dynamic> json) {
    return AudioSouraModel(
        id: json['reciter_id'] ?? 0,
        qare: _translateReciterName(json['reciter'] ?? ''),
        audioUrl: json['surah_audio'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {"reciter_id": id, "reciter": qare, "surah_audio": audioUrl};
  }

  // ================= دالة تحويل أسماء القراء للعربي =================
  static String _translateReciterName(String englishName) {
    String lowerName = englishName.toLowerCase();

    if (lowerName.contains('mishary') || lowerName.contains('alafasy')) {
      return 'مشاري بن راشد العفاسي';
    } else if (lowerName.contains('sudais')) {
      return 'عبدالرحمن السديس';
    } else if (lowerName.contains('abdul basit') && lowerName.contains('mujawwad')) {
      return 'عبدالباسط عبدالصمد (مجود)';
    } else if (lowerName.contains('abdul basit')) {
      return 'عبدالباسط عبدالصمد (مرتل)';
    } else if (lowerName.contains('maher') || lowerName.contains('muaiqly')) {
      return 'ماهر المعيقلي';
    } else if (lowerName.contains('ghamdi')) {
      return 'سعد الغامدي';
    } else if (lowerName.contains('shuraim')) {
      return 'سعود الشريم';
    } else if (lowerName.contains('juhany')) {
      return 'عبدالله الجهني';
    } else if (lowerName.contains('dosari') || lowerName.contains('dussary')) {
      return 'ياسر الدوسري';
    } else if (lowerName.contains('shatri') || lowerName.contains('shaatree')) {
      return 'أبو بكر الشاطري';
    } else if (lowerName.contains('rifai')) {
      return 'هاني الرفاعي';
    }

    return englishName; // لو الاسم مش في القائمة ينزل زي ما هو
  }
}
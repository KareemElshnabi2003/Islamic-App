import 'package:islamic_app/features/home/quran/domain/entities/varses_entity.dart';

class VarsesModel extends VarsesEntity {
  const VarsesModel({required super.id, required super.ayah});

  factory VarsesModel.fromJson(Map<String, dynamic> json) {
    return VarsesModel(
      id: json['ayah'] ?? 0,
      ayah: json['arabic'] ?? "", // 💡 بياخد النص العربي مباشرة
    );
  }

  Map<String, dynamic> toJson() {
    return {"ayah": id, "arabic": ayah};
  }
}
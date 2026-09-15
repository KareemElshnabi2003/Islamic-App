import 'package:islamic_app/features/drawer/doaa/domain/entities/doaa_entity.dart';

class DoaaModel extends DoaaEntity {
  final String categoryId; // ضفنا دي عشان نستخدمها في الفلترة بس

  const DoaaModel({
    required super.id,
    required this.categoryId,
    required super.arabic,
    required super.source,
    required super.repeat,
  });

  factory DoaaModel.fromJson(Map<String, dynamic> json) {
    return DoaaModel(
      id: json['id'] ?? 0,
      categoryId: json['category'] ?? '',
      arabic: json['arabic'] ?? '',
      source: json['source'] ?? '',
      repeat: json['repeat'] ?? 1,
    );
  }
}
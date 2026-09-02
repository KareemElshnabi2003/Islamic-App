import 'package:islamic_app/features/drawer/doaa/domain/entities/categories_entity.dart';
import 'package:islamic_app/features/drawer/doaa/domain/entities/doaa_entity.dart';

class CategoriesModel extends CategoriesEntity {
  const CategoriesModel({
    required super.id,
    required super.name,
    required super.count,
    required super.duas,
  });

  // الدالة دي بتاخد بيانات القسم، وبتاخد معاها لستة الأدعية اللي اتفلترت عشانه
  factory CategoriesModel.fromJson(Map<String, dynamic> json, List<DoaaEntity> categoryDuas) {
    return CategoriesModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
      duas: categoryDuas,
    );
  }
}
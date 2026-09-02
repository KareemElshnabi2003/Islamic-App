import 'package:equatable/equatable.dart';
import 'doaa_entity.dart';

class CategoriesEntity extends Equatable {
  final String id;
  final String name; // هنخزن فيه الاسم الإنجليزي مؤقتاً
  final int count;
  final List<DoaaEntity> duas; // الأدعية الخاصة بالقسم ده

  const CategoriesEntity({
    required this.id,
    required this.name,
    required this.count,
    required this.duas,
  });

  @override
  List<Object?> get props => [id, name, count, duas];
}
// "surah": {
// "number": 1,
// "name_arabic": "الفاتحة",
// },

import 'package:equatable/equatable.dart';

class SuraEntity extends Equatable {
  final int id;
  final String name;
  const SuraEntity({required this.id,required this.name});
  @override
  List<Object?> get props => [id,name];


}
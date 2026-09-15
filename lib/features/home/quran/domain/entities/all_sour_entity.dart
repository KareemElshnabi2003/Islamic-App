// "suwar": [
// {
// "id": 1,
// "name": "الفاتحة",
// "start_page": 1,
// "end_page": 1,
// "makkia": 1,
// "type": 0
// }

import 'package:equatable/equatable.dart';

class AllSourEntity extends Equatable{

  final int id;
  final String name;
  final int makia;
  const AllSourEntity({required this.id,required this.name,required this.makia});
  @override
  List<Object?> get props => [id,name,makia];


}
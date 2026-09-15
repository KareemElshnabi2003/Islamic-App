
import 'package:equatable/equatable.dart';

class HadethEntity extends Equatable {
  final String id ;
  final String collection;
  final String body;
  final int hadethNum;

 const HadethEntity({required this.id, required this.collection, required this.body, required this.hadethNum});

  @override
  List<Object?> get props => [id,collection,body,hadethNum];

}
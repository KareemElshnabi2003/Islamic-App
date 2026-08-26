import 'package:equatable/equatable.dart';

class RadioEntity extends  Equatable {

  final int id;
  final String name;
  final String url;
  final String recentDate;

  const RadioEntity({required this.id,required this.name,required this.url,required this.recentDate});




  @override
  List<Object?> get props => [id,name,url,recentDate];

}
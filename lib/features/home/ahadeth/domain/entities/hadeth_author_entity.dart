import 'package:equatable/equatable.dart';

class HadethAuthorEntity extends Equatable {

  final String  key;
   final String arabicName;
  final int totalAhadeth;

 const HadethAuthorEntity({required this.key, required this.arabicName, required this.totalAhadeth});

  @override
  List<Object?> get props =>[key,totalAhadeth,arabicName];
}


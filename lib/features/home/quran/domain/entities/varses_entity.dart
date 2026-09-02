// {
// "ayah": 1,
// "arabic": "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
// },

import 'package:equatable/equatable.dart';

class VarsesEntity extends Equatable {
  final int id;
  final String ayah;
  const VarsesEntity({required this.id,required this.ayah});
  @override
  List<Object?> get props => [id,ayah];


}
import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_entity.dart';

abstract class AhadethState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HadethInitial extends AhadethState {

}

class HadethLoading extends AhadethState {

}

class HadethSuccess extends AhadethState {
  final List<HadethEntity> ahadeth;


  HadethSuccess({
    required this.ahadeth,

  });



  @override
  List<Object?> get props => [ahadeth];
}

class HadethError extends AhadethState {
  final String message;
  HadethError({required this.message});

  @override
  List<Object?> get props => [message];
}
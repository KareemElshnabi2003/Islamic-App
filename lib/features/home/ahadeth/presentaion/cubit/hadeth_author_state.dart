import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/home/ahadeth/domain/entities/hadeth_author_entity.dart';


abstract class HadethAuthorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HadethAuthorInitial extends HadethAuthorState {

}

class HadethAuthorLoading extends HadethAuthorState {

}

class HadethAuthorSuccess extends HadethAuthorState {
  final List<HadethAuthorEntity> authors;

  HadethAuthorSuccess({
    required this.authors,

  });



  @override
  List<Object?> get props => [authors];
}

class HadethAuthorError extends HadethAuthorState {
  final String message;
  HadethAuthorError({required this.message});

  @override
  List<Object?> get props => [message];
}
import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/drawer/doaa/domain/entities/categories_entity.dart';

abstract class DoaaState extends Equatable {
  const DoaaState();

  @override
  List<Object?> get props => [];
}

class DoaaInitial extends DoaaState {}

class DoaaLoading extends DoaaState {}



class DoaaSuccess extends DoaaState {
  final List<CategoriesEntity> categories;

 const DoaaSuccess({
    required this.categories,
  });



  @override
  List<Object?> get props => [categories];
}

class DoaaError extends DoaaState {
  final String message;

  const DoaaError({required this.message});

  @override
  List<Object?> get props => [message];
}
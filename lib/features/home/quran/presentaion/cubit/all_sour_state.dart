import 'package:equatable/equatable.dart';
import 'package:islamic_app/features/home/quran/domain/entities/all_sour_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/home/quran/domain/usecases/get_all_sour_use_case.dart';

// ================= State =================
abstract class AllSourState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AllSourInitial extends AllSourState {}
class AllSourLoading extends AllSourState {}

class AllSourSuccess extends AllSourState {
  final List<AllSourEntity> allSour;
  AllSourSuccess({required this.allSour});

  @override
  List<Object?> get props => [allSour];
}

class AllSourError extends AllSourState {
  final String message;
  AllSourError({required this.message});

  @override
  List<Object?> get props => [message];
}


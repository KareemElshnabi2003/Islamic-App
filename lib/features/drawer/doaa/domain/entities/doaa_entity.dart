import 'package:equatable/equatable.dart';

class DoaaEntity extends Equatable {
  final int id;
  final String arabic;
  final String source;
  final int repeat;

  const DoaaEntity({
    required this.id,
    required this.arabic,
    required this.source,
    required this.repeat,
  });

  @override
  List<Object?> get props => [id, arabic, source, repeat];
}
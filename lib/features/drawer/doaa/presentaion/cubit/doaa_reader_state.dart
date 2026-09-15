import 'package:equatable/equatable.dart';

class DoaaReaderState extends Equatable {
  final int currentIndex;
  const DoaaReaderState({this.currentIndex = 0});

  DoaaReaderState copyWith({int? currentIndex}) {
    return DoaaReaderState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object> get props => [currentIndex];
}


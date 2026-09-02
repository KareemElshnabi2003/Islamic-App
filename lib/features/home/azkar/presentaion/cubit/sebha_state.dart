class SebhaState {
  final int counter;
  final int zekrIndex;
  final double rotationAngle;

  SebhaState({
    this.counter = 0,
    this.zekrIndex = 0,
    this.rotationAngle = 0.0,
  });

  SebhaState copyWith({
    int? counter,
    int? zekrIndex,
    double? rotationAngle,
  }) {
    return SebhaState(
      counter: counter ?? this.counter,
      zekrIndex: zekrIndex ?? this.zekrIndex,
      rotationAngle: rotationAngle ?? this.rotationAngle,
    );
  }
}
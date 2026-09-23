abstract class QiblaState {}

class QiblaInitial extends QiblaState {}

class QiblaLoading extends QiblaState {}

class QiblaSuccess extends QiblaState {
  final double qiblaBearing;
  QiblaSuccess({required this.qiblaBearing});
}

class QiblaPermissionDenied extends QiblaState {}
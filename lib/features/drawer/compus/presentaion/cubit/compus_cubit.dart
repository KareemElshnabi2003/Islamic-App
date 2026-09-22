import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/services/location/location_services.dart';
import 'package:islamic_app/features/drawer/compus/presentaion/cubit/compus_state.dart';


class QiblaCubit extends Cubit<QiblaState> {
  final LocationService locationService;

  QiblaCubit({required this.locationService}) : super(QiblaInitial());

  Future<void> getQiblaDirection() async {
    bool hasEmittedCache = false;
    const double kaabaLat = 21.422487;
    const double kaabaLng = 39.826206;

    // 1. استخدام آخر موقع معروف لعرض القبلة بشكل فوري (بسرعة فائقة)
    final lastPosition = await locationService.getLastKnownLocation();
    if (lastPosition != null && !isClosed) {
      double bearing = Geolocator.bearingBetween(
        lastPosition.latitude,
        lastPosition.longitude,
        kaabaLat,
        kaabaLng,
      );
      emit(QiblaSuccess(qiblaBearing: bearing));
      hasEmittedCache = true;
    }

    if (!hasEmittedCache) {
      emit(QiblaLoading());
    }

    // 2. تحديث الموقع بدقة عالية في الخلفية
    final position = await locationService.getCurrentLocation();

    if (position != null) {
      if (isClosed) return;
      double bearing = Geolocator.bearingBetween(
        position.latitude,
        position.longitude,
        kaabaLat,
        kaabaLng,
      );
      emit(QiblaSuccess(qiblaBearing: bearing));
    } else {
      if (!hasEmittedCache && !isClosed) {
        emit(QiblaPermissionDenied());
      }
    }
  }
}
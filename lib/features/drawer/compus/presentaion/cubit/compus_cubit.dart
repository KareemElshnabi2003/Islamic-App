import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/services/location/location_services.dart';
import 'package:islamic_app/features/drawer/compus/presentaion/cubit/compus_state.dart';


class QiblaCubit extends Cubit<QiblaState> {
  final LocationService locationService;

  QiblaCubit({required this.locationService}) : super(QiblaInitial());

  Future<void> getQiblaDirection() async {
    emit(QiblaLoading());

    final position = await locationService.getCurrentLocation();

    if (position != null) {
      const double kaabaLat = 21.422487;
      const double kaabaLng = 39.826206;

      double bearing = Geolocator.bearingBetween(
        position.latitude,
        position.longitude,
        kaabaLat,
        kaabaLng,
      );

      emit(QiblaSuccess(qiblaBearing: bearing));
    } else {
      emit(QiblaPermissionDenied());
    }
  }
}
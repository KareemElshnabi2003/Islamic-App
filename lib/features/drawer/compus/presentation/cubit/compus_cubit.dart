import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/core/services/location/location_services.dart';
import 'package:islamic_app/features/drawer/compus/presentation/cubit/compus_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  final LocationService locationService;

  QiblaCubit({required this.locationService}) : super(QiblaInitial());

  Future<void> getQiblaDirection() async {
    bool hasEmittedCache = false;
    const double kaabaLat = 21.422487;
    const double kaabaLng = 39.826206;

    try {
      // 1. استخدام الموقع المحفوظ مسبقاً (من أوقات الصلاة أو جلسة سابقة) للعرض الفوري
      final dynamic cachedLatVal = CacheHelper.getData(key: "CACHED_LAT");
      final dynamic cachedLngVal = CacheHelper.getData(key: "CACHED_LNG");
      if (cachedLatVal != null && cachedLngVal != null) {
        final double? lat = double.tryParse(cachedLatVal.toString());
        final double? lng = double.tryParse(cachedLngVal.toString());
        if (lat != null && lng != null && !isClosed) {
          double bearing = Geolocator.bearingBetween(lat, lng, kaabaLat, kaabaLng);
          emit(QiblaSuccess(qiblaBearing: bearing));
          hasEmittedCache = true;
        }
      }

      // 2. استخدام آخر موقع معروف من GPS
      if (!hasEmittedCache) {
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
      }

      if (!hasEmittedCache && !isClosed) {
        emit(QiblaLoading());
      }

      // 3. محاولة جلب الموقع الحالي وتحديث القبلة وحفظ الإحداثيات
      final position = await locationService.getCurrentLocation();

      if (position != null) {
        if (isClosed) return;
        double bearing = Geolocator.bearingBetween(
          position.latitude,
          position.longitude,
          kaabaLat,
          kaabaLng,
        );
        await CacheHelper.saveData(key: "CACHED_LAT", value: position.latitude);
        await CacheHelper.saveData(key: "CACHED_LNG", value: position.longitude);
        emit(QiblaSuccess(qiblaBearing: bearing));
      } else {
        if (!hasEmittedCache && !isClosed) {
          emit(QiblaPermissionDenied());
        }
      }
    } catch (_) {
      if (!hasEmittedCache && !isClosed) {
        emit(QiblaPermissionDenied());
      }
    }
  }
}
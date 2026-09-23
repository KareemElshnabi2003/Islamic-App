import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islamic_app/core/services/location/location_services.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';
import 'package:islamic_app/features/drawer/times/domain/usecases/get_times_use_case.dart';
import 'package:islamic_app/features/drawer/times/presentation/cubit/times_state.dart';

class TimesCubit extends Cubit<TimesState> {
  final GetTimesUseCase getTimesUseCase;
  final LocationService locationService;

  TimesCubit({required this.getTimesUseCase, required this.locationService}) : super(TimesInitial());

  String? country;

  Future<void> getTimes() async {
    final String today = getSimpleDate();
    bool hasEmittedCache = false;

    // 1. Optimistic Cache Load (Instant UI)
    final cachedDate = CacheHelper.getData(key: "CACHED_TIMES_DATE");
    if (cachedDate == today) {
      final double? cachedLat = CacheHelper.getData(key: "CACHED_LAT");
      final double? cachedLng = CacheHelper.getData(key: "CACHED_LNG");
      final String? cachedCity = CacheHelper.getData(key: "CACHED_CITY");

      if (cachedLat != null && cachedLng != null && cachedCity != null) {
        country = cachedCity;
        final result = await getTimesUseCase.call(date: today, lat: cachedLat, lang: cachedLng);
        result.fold((l) {}, (times) {
          if (!isClosed) {
            emit(TimesSuccess(
              times: times,
              cityName: country ?? "موقع غير معروف",
              gregorianDate: getGregorianDate(),
              hijriDate: getHijriDate(),
            ));
            hasEmittedCache = true;
          }
        });
      }
    }

    if (!hasEmittedCache) {
      emit(TimesLoading());
    }

    try {
      // 2. Background GPS Update
      Position? pos = await locationService.getCurrentLocation();
      if (pos == null) {
        if (!hasEmittedCache) {
          emit(TimesError(message: "لم نتمكن من تحديد الموقع، يرجى تفعيل الـ GPS"));
        }
        return;
      }

      double lat = pos.latitude;
      double lng = pos.longitude;
      country = await getCityNameLocal(lat, lng);

      // Save GPS coordinates for next quick load
      await CacheHelper.saveData(key: "CACHED_LAT", value: lat);
      await CacheHelper.saveData(key: "CACHED_LNG", value: lng);
      await CacheHelper.saveData(key: "CACHED_CITY", value: country);

      final result = await getTimesUseCase.call(
          date: today,
          lang: lng,
          lat: lat
      );

      result.fold(
            (failure) {
              if (isClosed || hasEmittedCache) return;
              emit(TimesError(message: failure.errorModel.errorMessage));
        },
            (times) {
              if (isClosed) return;
              emit(TimesSuccess(
            times: times,
            cityName: country ?? "موقع غير معروف",
            gregorianDate: getGregorianDate(),
            hijriDate: getHijriDate(),
          ));
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Times error: $e");
      debugPrint(stackTrace.toString());
      if (!hasEmittedCache) {
        emit(TimesError(message: "حدث خطأ غير متوقع"));
      }
    }
  }


  String getSimpleDate() {
    return DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  String getGregorianDate() {
    Intl.defaultLocale = 'ar';
    return DateFormat('EEEE ، d MMMM yyyy').format(DateTime.now());
  }

  String getHijriDate() {
    HijriCalendar.setLocal('ar');
    HijriCalendar hijriDate = HijriCalendar.fromDate(DateTime.now());
    return "${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} هـ";
  }

  String convertTime(String time24) {
    DateTime parsedTime = DateFormat("HH:mm").parse(time24);
    return DateFormat("h:mm a", "en_US").format(parsedTime);
  }

  Future<String> getCityNameLocal(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lng,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String cityName = place.locality ?? place.administrativeArea ?? "غير معروف";
        return cityName;
      }
    } catch (e) {
      debugPrint("City name error: $e");
    }
    return "موقع غير معروف";
  }
}
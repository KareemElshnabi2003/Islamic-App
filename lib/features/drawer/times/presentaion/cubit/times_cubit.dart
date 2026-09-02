import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islamic_app/core/services/location/location_services.dart';
import 'package:islamic_app/features/drawer/times/domain/usecases/get_times_use_case.dart';
import 'package:islamic_app/features/drawer/times/presentaion/cubit/times_state.dart';

class TimesCubit extends Cubit<TimesState> {
  final GetTimesUseCase getTimesUseCase;
  final LocationService locationService;

  TimesCubit({required this.getTimesUseCase, required this.locationService}) : super(TimesInitial());

  String? country;

  Future<void> getTimes() async {
    emit(TimesLoading());

    try {
      Position? pos = await locationService.getCurrentLocation();
      if (pos == null) {
        emit(TimesError(message: "لم نتمكن من تحديد الموقع، يرجى تفعيل الـ GPS"));
        return;
      }

      double lat = pos.latitude;
      double lng = pos.longitude;

      country = await getCityNameLocal(lat, lng);

      final result = await getTimesUseCase.call(
          date: getSimpleDate(),
          lang: lng,
          lat: lat
      );


      result.fold(
            (failure) {
              if (isClosed) return; // السطر ده للحماية

              emit(TimesError(message: failure.errorModel.errorMessage));
        },
            (times) {
              print("times $times");
              print("country $country");
              print("date ${getGregorianDate()}");
              print("hijri ${getHijriDate()}");
              if (isClosed) return; // السطر ده للحماية

              emit(TimesSuccess(
            times: times,
            cityName: country ?? "موقع غير معروف",
            gregorianDate: getGregorianDate(),
            hijriDate: getHijriDate(),
          ));
        },
      );
    } catch (e,stackTrace) {
      print("السبب الحقيقي للخطأ: $e"); // عشان تشوف المشكلة بعينك في الكونسول
      print(stackTrace);
      emit(TimesError(message: "حدث خطأ غير متوقع"));    }
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
      print("خطأ في جلب اسم المدينة: $e");
    }
    return "موقع غير معروف";
  }
}
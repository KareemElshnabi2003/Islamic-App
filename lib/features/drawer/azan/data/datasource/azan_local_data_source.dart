import 'dart:convert';
import 'package:islamic_app/features/drawer/times/data/model/times_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAdhanLocalDataSource {
  Future<TimesModel> getCachedPrayerTimes();
}

class AdhanLocalDataSourceImpl implements BaseAdhanLocalDataSource {
  final SharedPreferences sharedPreferences;

  AdhanLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<TimesModel> getCachedPrayerTimes() async {
    final jsonString = sharedPreferences.getString('CACHED_TIMES_AZAN');
    if (jsonString != null) {
      return TimesModel.fromJson(json.decode(jsonString));
    } else {
      throw Exception("No cached times found");
    }
  }
}
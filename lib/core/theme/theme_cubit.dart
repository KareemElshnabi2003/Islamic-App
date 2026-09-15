
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/helper/cache_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const String _themeKey = 'isDarkMode';

  void _loadTheme() {
    final isDark = CacheHelper.getData(key: _themeKey) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    final isCurrentlyDark = state == ThemeMode.dark;
    
    await CacheHelper.saveData(key: _themeKey, value: !isCurrentlyDark);
    
    emit(!isCurrentlyDark ? ThemeMode.dark : ThemeMode.light);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubits extends Cubit<ThemeData> {
  ThemeCubits(Color initialColor) : super(createTheme(initialColor));



  static ThemeData createTheme(Color c1) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: c1,
        brightness: Brightness.light,
      ),
    );
  }

   Future<void> changeColor(Color c1) async {
    emit(createTheme(c1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_color', c1.value);
  }
}

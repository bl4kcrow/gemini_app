import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const seedColor = Color(0xFF2399f5); // Vibrant Indigo

class AppTheme {
  AppTheme({required this.isDarkMode});
  final bool isDarkMode;

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seedColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,

    listTileTheme: const ListTileThemeData(iconColor: seedColor),

    appBarTheme: const AppBarTheme(
      backgroundColor: seedColor,
      foregroundColor: Colors.white, // Ensure text is visible on dark primary color
      surfaceTintColor: Colors.transparent,
    ),
  );

  static setSytemUIOverlayStyle(bool isDarkMode) {
    final themeBrightness = isDarkMode ? Brightness.dark : Brightness.light;
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: themeBrightness,
        statusBarBrightness: themeBrightness,
        systemNavigationBarIconBrightness: themeBrightness,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
}

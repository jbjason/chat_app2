import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData selectedTheme = AppTheme.dark();

  ThemeData get getTheme => selectedTheme;

  void switchTheme() {
    final _isTheme = selectedTheme == AppTheme.dark();
    selectedTheme = _isTheme ? AppTheme.light() : AppTheme.dark();
    notifyListeners();
  }
}

abstract class AppColors {
  static const secondary = Color(0xFF3B76F6);
  static const accent = Color(0xFFD6755B);
  static const textDark = Color(0xFF53585A);
  static const textLigth = Color(0xFFF5F5F5);
  static const textFaded = Color(0xFF9899A5);
  static const iconLight = Color(0xFFB1B4C0);
  static const iconDark = Color(0xFFB1B3C1);
  static const textHighlight = secondary;
  static const cardLight = Color(0xFFEEEEEE);
  static const cardDark = Color(0xFF303334);
}

abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  /// Light theme and its settings.
  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        visualDensity: visualDensity,
        // ignore: deprecated_member_use
        accentColor: AppColors.accent,
        textTheme: GoogleFonts.mulishTextTheme(
          const TextTheme(
            headline1: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
            bodyText1: TextStyle(
              color: AppColors.textDark,
              fontSize: 11,
              letterSpacing: 0.3,
              fontWeight: FontWeight.bold,
            ),
            bodyText2: TextStyle(
              fontSize: 12,
              color: AppColors.textFaded,
              letterSpacing: -0.3,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        cardColor: AppColors.cardLight,
        iconTheme: const IconThemeData(color: AppColors.iconDark),
      );

  /// Dark theme and its settings.
  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        visualDensity: visualDensity,
        // ignore: deprecated_member_use
        accentColor: AppColors.accent,
        textTheme: GoogleFonts.interTextTheme(
          const TextTheme(
            headline1: TextStyle(
              color: AppColors.textLigth,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            headline2: TextStyle(
              color: AppColors.textLigth,
              letterSpacing: 0.2,
              wordSpacing: 1.5,
              fontWeight: FontWeight.w900,
            ),
            bodyText1: TextStyle(
              color: AppColors.textLigth,
              fontSize: 11,
              letterSpacing: 0.3,
              fontWeight: FontWeight.bold,
            ),
            bodyText2: TextStyle(
                fontSize: 11, color: AppColors.textFaded, letterSpacing: -0.3),
          ),
        ),
        backgroundColor: const Color(0xFF1B1E1F),
        scaffoldBackgroundColor: const Color(0xFF1B1E1F),
        cardColor: AppColors.cardDark,
        iconTheme: const IconThemeData(color: AppColors.iconLight),
      );
}

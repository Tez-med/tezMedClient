import 'package:flutter/material.dart';
import 'package:tez_med_client/core/utils/app_color.dart';
import 'package:tez_med_client/core/utils/app_textstyle.dart';

class AppTheme {
  // Instantiation qilishni oldini olish uchun private konstruktor
  AppTheme._();

  // Yorug' tema
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: AppColor.buttonBackColor,

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      // ColorScheme
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColor.primaryColor,
        onPrimary: Colors.white,
        secondary: AppColor.secondary,
        onSecondary: Colors.white,
        error: AppColor.error,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: AppColor.textColor,
      ),

      // AppBar dizayni
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: AppColor.buttonBackColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextstyle.nunitoBold.copyWith(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: AppColor.primaryDark),
      ),

      // Button dizayni
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.primaryColor,
          side: const BorderSide(color: AppColor.primaryColor),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.primaryColor,
        ),
      ),

      // Card dizayni
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input dizayni
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColor.buttonBackColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.error),
        ),
        hintStyle: const TextStyle(color: AppColor.greyTextColor),
      ),

      // Text dizayni
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColor.textColor,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColor.textColor,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColor.textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColor.textColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColor.greyTextColor,
        ),
      ),

      // Chip dizayni
      chipTheme: ChipThemeData(
        backgroundColor: AppColor.buttonBackColor,
        disabledColor: AppColor.greyTextColor.withValues(alpha: 0.2),
        selectedColor: AppColor.primaryColor,
        secondarySelectedColor: AppColor.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(color: AppColor.textColor),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // TabBar dizayni
      tabBarTheme: const TabBarTheme(
        labelColor: AppColor.primaryColor,
        unselectedLabelColor: AppColor.greyTextColor,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 2.0, color: AppColor.primaryColor),
        ),
      ),

      // FloatingActionButton dizayni
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Qora tema
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: AppColor.primaryDark,

      // ColorScheme
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColor.primaryColor,
        onPrimary: Colors.white,
        secondary: AppColor.secondary,
        onSecondary: Colors.white,
        error: AppColor.error,
        onError: Colors.white,
        surface: AppColor.secondary,
        onSurface: Colors.white,
      ),

      // AppBar dizayni
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.primaryDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
      ),

      // Qora tema uchun boshqa komponentlar...
      // (Shu yerda qora reja uchun boshqa dizayn elementlarini ham qo'shib ketishingiz mumkin)
    );
  }
}

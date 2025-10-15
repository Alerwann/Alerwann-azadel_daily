import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColors = Color(0xFF7F00FF);
  static const Color secondaryColors = Color(0xFFFFD54F);
  static const Color thirdColors = Color(0xFFB388FF);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColors,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColors,
        primary: primaryColors,
        secondary: secondaryColors,
        tertiary: thirdColors,
        surface: Color(0xFFFAFAFA),
      ),
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      useMaterial3: true,

      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),

        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),

        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),

        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),

        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),

        bodySmall: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryColors,
        foregroundColor: Colors.white, // Couleur du texte/icônes
        elevation: 4, // Ombre
        centerTitle: true, // Centrer le titre
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColors, // Couleur de fond
          foregroundColor: Colors.white, // Couleur du texte
          elevation: 5,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColors,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColors,
        brightness: Brightness.dark, // ← Important
        primary: thirdColors, // Violet plus clair en dark mode
        secondary: secondaryColors,
        tertiary: primaryColors,
        surface: Color(0xFF1E1E1E), // Fond sombre
      ),

      scaffoldBackgroundColor: Color(0xFF121212), // Fond très sombre
      useMaterial3: true,

      // Texte
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white, // ← Blanc en dark mode
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
        bodySmall: TextStyle(fontSize: 12, color: Colors.grey[400]),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E), // Sombre
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),

      // Boutons (gardent les mêmes couleurs)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: thirdColors, // Violet clair en dark
          foregroundColor: Colors.white,
          elevation: 5,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

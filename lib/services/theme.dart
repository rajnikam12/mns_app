import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 188, 50, 8);
  static const Color accentColor = Color(0xFF0277BD);
  static const Color backgroundColor = Color(0xFFF5F6F5);
  static const Color textColor = Color(0xFF1C2526);
  static const Color secondaryTextColor = Color(0xFF6B7280);

  static final String? fontFamily = GoogleFonts.montserrat().fontFamily;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: textColor,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 28,
          color: textColor,
        ),
        headlineLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: textColor,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: textColor,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: textColor,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: textColor,
        ),
        bodySmall: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: secondaryTextColor,
        ),
        labelLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: textColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: secondaryTextColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        labelStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: secondaryTextColor,
        ),
        hintStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: secondaryTextColor,
        ),
      ),
      iconTheme: const IconThemeData(color: textColor, size: 24),
      dividerTheme: const DividerThemeData(
        color: secondaryTextColor,
        thickness: 1,
        space: 16,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 28,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.white70,
        ),
        bodySmall: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.white54,
        ),
        labelLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        labelStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.white54,
        ),
        hintStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.white54,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
      dividerTheme: const DividerThemeData(
        color: Colors.white54,
        thickness: 1,
        space: 16,
      ),
    );
  }
}

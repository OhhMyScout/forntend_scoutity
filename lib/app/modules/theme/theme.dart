import 'package:flutter/material.dart';

class AppTheme {
  // Warna Utama (diambil dari Tailwind Config kamu)
  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color secondary = Color(0xFF7D562D);
  static const Color onSurfaceVariant = Color(0xFF504442);

  // Tambahan warna pendukung dari Tailwind untuk kebutuhan UI Game
  static const Color secondaryContainer = Color(0xFFFFCA98);
  static const Color onSecondaryContainer = Color(0xFF7A532A);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E3);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DD);
  static const Color outlineColor = Color(0xFF827471);
  static const Color outlineVariantColor = Color(0xFFD4C3BF);
  static const Color errorColor = Color(0xFFBA1A1A);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      
      // Mengisi ColorScheme M3 secara lengkap agar komponen di view bisa membaca otomatis
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        surface: background,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
        outline: outlineColor,
        outlineVariant: outlineVariantColor,
        error: errorColor,
        onError: Colors.white,
      ),

      // Set font default sesuai branding Scoutify
      fontFamily: 'Urbanist',
      textTheme: const TextTheme(
        // Dipakai untuk Judul Besar "Scoutify" / "KAMU KALAH!"
        headlineLarge: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: primary,
          fontSize: 32,
        ),
        // Dipakai untuk sub-judul / judul challenge
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: primary,
          fontSize: 24,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: primary,
          fontSize: 20,
        ),
        // Dipakai untuk teks bodi utama
        bodyLarge: TextStyle(
          fontFamily: 'Urbanist',
          color: onSurfaceVariant,
          fontSize: 16,
        ),
        // Dipakai untuk teks informasi kecil / label opsi
        labelMedium: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
          color: outlineColor,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Diubah ke rounded-xl sesuai HTML Tailwind
          ),
          textStyle: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
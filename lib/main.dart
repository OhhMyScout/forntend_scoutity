// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Scoutify",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Urbanist', // Pastikan sudah didaftarkan di pubspec.yaml
        colorSchemeSeed: const Color(0xFF361F1A),
      ),
    ),
  );
}

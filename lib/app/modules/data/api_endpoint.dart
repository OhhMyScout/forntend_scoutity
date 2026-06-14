import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoint {
  // Mengambil Base URL dari .env
  // Jika .env belum ter-load, gunakan localhost sebagai backup
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? "https://haisen.my.id//api";

  // ==========================================
  // Auth & Profile
  // ==========================================
  static String get register => "$baseUrl/register";
  static String get login => "$baseUrl/login";
  static String get verifyOtp => "$baseUrl/verify-otp";
  static String get verifyForgotOtp => "$baseUrl/verify-otp-reset";
  static String get resendOtpRegister => "$baseUrl/resend-otp";
  static String get resendOtpReset => "$baseUrl/resend-otp-reset";
  static String get profile => "$baseUrl/profile";
  static String get logout => "$baseUrl/logout";
  static String get forgotPassword => "$baseUrl/forgot-password";
  static String get resetPassword => "$baseUrl/reset-password";

  // ==========================================
  // Games & Leaderboard
  // ==========================================
  static String get leaderboard => "$baseUrl/leaderboard";
  static String get gameScore => "$baseUrl/game-scores";
  static String get games => "$baseUrl/games";
  static String get submitScore => "$baseUrl/score";

  // ==========================================
  // Get Questions
  // ==========================================
  static String get kotak1Questions => "$baseUrl/games/kotak1/questions";
  static String get kotak2Questions => "$baseUrl/games/kotak2/questions";
  static String get morseQuestions => "$baseUrl/games/morse/questions";

  // ==========================================
  // BERITA
  // ==========================================
  static String get beritaProvinsi => "$baseUrl/berita/provinsi";
  static String get beritaProvinsiTop10 => "$baseUrl/berita/provinsi/top10";
  static String get berita => "$baseUrl/berita";
  static String get beritaPopuler => "$baseUrl/berita/populer";
  
  // ==========================================
  // Deteksi Semaphore
  // ==========================================
  static String get semaphoreDetect => "$baseUrl/deteksi/semaphore";
}
// lib/app/data/api_endpoint.dart

class ApiEndpoint {
  // IP ini pastikan adalah IP Laptop/Server Backend kamu
  static const String baseUrl = "http://10.137.42.242:5000/api";

  // ==========================================
  // Auth & Profile
  // ==========================================
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  
  // Endpoint Verifikasi OTP
  static const String verifyOtp = "$baseUrl/verify-otp";
  static const String verifyForgotOtp = "$baseUrl/verify-otp-reset"; // <-- Ditambahkan untuk forgot password
  
  // Endpoint Resend OTP
  static const String resendOtpRegister = "$baseUrl/resend-otp";
  static const String resendOtpReset = "$baseUrl/resend-otp-reset";
  
  static const String profile = "$baseUrl/profile";
  static const String logout = "$baseUrl/logout"; // <-- Typo huruf 's' di bawah sini sudah dihapus
  
  // Fitur Lupa Password
  static const String forgotPassword = "$baseUrl/forgot-password"; 
  static const String resetPassword = "$baseUrl/reset-password";

  // ==========================================
  // Games & Leaderboard
  // ==========================================
  // Untuk mengambil Total Poin Akumulasi (Leaderboard Global)
  static const String leaderboard = "$baseUrl/leaderboard"; 
  
  // Untuk mengambil Leaderboard per-game (Sandi Kotak 1, dll)
  static const String gameScore = "$baseUrl/game-scores"; 
  
  // Untuk mengambil daftar mini games yang tersedia
  static const String games = "$baseUrl/games";
  
  // Untuk mengirim/menyimpan skor setelah selesai bermain
  static const String submitScore = "$baseUrl/score"; 

  // ==========================================
  // Get Questions dari API (Bank Soal)
  // ==========================================
  static const String kotak1Questions = "$baseUrl/games/kotak1/questions";
  static const String kotak2Questions = "$baseUrl/games/kotak2/questions";
  static const String morseQuestions = "$baseUrl/games/morse/questions";
}
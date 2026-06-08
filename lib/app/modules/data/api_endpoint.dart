// lib/app/data/api_endpoint.dart

class ApiEndpoint {
  // ==========================================
  // ENVIRONMENT SETUP
  // ==========================================

  // Ubah nilai ini menjadi:
  // true  -> Jika aplikasi ingin di-build/rilis (pakai domain trycenter)
  // false -> Jika sedang ngoding/testing di emulator (pakai IP Laptop)
  static const bool isProduction = false;

  // 1. URL Local (Development)
  static const String _localBaseUrl = "http://10.137.17.154:5000/api";

  // 2. URL Domain (Production)
  // Pastikan Anda memilih URL yang sesuai dengan setup backend Anda.
  // Jika backend di-host di subdomain 'api', gunakan baris pertama.
  static const String _prodBaseUrl = "https://api.trycenter.my.id/api";
  // static const String _prodBaseUrl = "https://trycenter.my.id/api";

  // Variabel utama yang akan menyesuaikan otomatis berdasarkan flag isProduction
  static const String baseUrl = isProduction ? _prodBaseUrl : _localBaseUrl;

  // ==========================================
  // Auth & Profile
  // ==========================================
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";

  // Endpoint Verifikasi OTP
  static const String verifyOtp = "$baseUrl/verify-otp";
  static const String verifyForgotOtp = "$baseUrl/verify-otp-reset";

  // Endpoint Resend OTP
  static const String resendOtpRegister = "$baseUrl/resend-otp";
  static const String resendOtpReset = "$baseUrl/resend-otp-reset";

  static const String profile = "$baseUrl/profile";
  static const String logout = "$baseUrl/logout";

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

  // ==========================================
  // BERITA
  // ==========================================
  static const String beritaProvinsi = "$baseUrl/berita/provinsi";
  static const String beritaProvinsiTop10 = "$baseUrl/berita/provinsi/top10";
  static const String berita = "$baseUrl/berita";
  static const String beritaPopuler = "$baseUrl/berita/populer";
}

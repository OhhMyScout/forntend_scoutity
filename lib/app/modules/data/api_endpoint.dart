// lib/app/data/services/api_endpoint.dart

class ApiEndpoint {
  // 1. Alamat Base URL Utama (Pusatnya di sini bray!)
  static const String baseUrl = "http://10.137.97.153:5000/api";
  
  // Jika pakai Emulator Android bawaan, kadang butuh IP ini bray:
  // static const String baseUrl = "http://10.0.2.2:5000/api";

  // 2. Daftar Anak Rute (Endpoints) Scoutify
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String verifyOtp = "$baseUrl/verify-otp";
  static const String resendOtpRegister = "$baseUrl/resend-otp";
  static const String resendOtpReset = "$baseUrl/resend-otp-reset";
  // static const String profile = "$baseUrl/profile"; // Persiapan buat Get Profile bray
}
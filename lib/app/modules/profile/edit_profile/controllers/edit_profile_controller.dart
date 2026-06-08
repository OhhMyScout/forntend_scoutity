import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/api_endpoint.dart';
import '../../../../routes/app_pages.dart';

class EditProfileController extends GetxController {
  final GetStorage box = GetStorage();

  // ================= TEXT CONTROLLERS =================
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final unitController = TextEditingController();

  // ================= STATE =================
  var isLoading = false.obs;
  var isReady = false.obs;

  // ================= DROPDOWN =================
  var selectedProvince = RxnString();

  final List<String> provinces = [
    "Aceh","Sumatera Utara","Sumatera Barat","Riau","Kepulauan Riau",
    "Jambi","Sumatera Selatan","Bangka Belitung","Bengkulu","Lampung",
    "DKI Jakarta","Jawa Barat","Jawa Tengah","DI Yogyakarta","Jawa Timur",
    "Banten","Bali","Nusa Tenggara Barat","Nusa Tenggara Timur",
    "Kalimantan Barat","Kalimantan Tengah","Kalimantan Selatan",
    "Kalimantan Timur","Kalimantan Utara","Sulawesi Utara",
    "Sulawesi Tengah","Sulawesi Selatan","Sulawesi Tenggara",
    "Gorontalo","Sulawesi Barat","Maluku","Maluku Utara",
    "Papua","Papua Barat","Papua Selatan","Papua Tengah",
    "Papua Pegunungan","Papua Barat Daya",
  ];

  // =====================================================
  // INIT
  // =====================================================
  @override
  void onInit() {
    super.onInit();
    fetchProfileFromAPI();
  }

  // =====================================================
  // FETCH PROFILE (SOURCE OF TRUTH)
  // =====================================================
  Future<void> fetchProfileFromAPI() async {
    try {
      isLoading.value = true;
      isReady.value = false;

      final token = box.read("token");

      if (token == null || token.toString().isEmpty) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoint.profile),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data["user"];

        // ================= SET CONTROLLERS =================
        nameController.text = user["fullname"] ?? "";
        emailController.text = user["email"] ?? "";
        usernameController.text = user["username"] ?? "";
        unitController.text = user["gudep"] ?? "";

        final province = user["province"];

        selectedProvince.value =
            (province != null && provinces.contains(province))
                ? province
                : provinces.first;

        // ================= CACHE LOCAL =================
        await box.write("fullname", user["fullname"]);
        await box.write("email", user["email"]);
        await box.write("username", user["username"]);
        await box.write("gudep", user["gudep"]);
        await box.write("province", user["province"]);
        await box.write("user_id", user["id"]);
      } else if (response.statusCode == 401) {
        await logout();
      } else {
        Get.snackbar("Error", "Gagal mengambil data profile");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error");
    } finally {
      isLoading.value = false;
      isReady.value = true;
    }
  }

  // =====================================================
  // CHANGE PROVINCE
  // =====================================================
  void changeProvince(String? value) {
    if (value != null) {
      selectedProvince.value = value;
    }
  }

  // =====================================================
  // SAVE PROFILE (UPDATE DB)
  // =====================================================
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;

      final token = box.read("token");

      final body = {
        "fullname": nameController.text.trim(),
        "email": emailController.text.trim(),
        "username": usernameController.text.trim(),
        "gudep": unitController.text.trim(),
        "province": selectedProvince.value,
      };

      final response = await http.put(
        Uri.parse("${ApiEndpoint.baseUrl}/profile/update"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        await fetchProfileFromAPI();

        Get.back();
        Get.snackbar("Sukses", "Profile berhasil diupdate");
      } else {
        Get.snackbar("Error", "Gagal update profile");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error");
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // PICK IMAGE (PLACEHOLDER)
  // =====================================================
  void pickImage() {
    Get.snackbar("Info", "Upload foto belum tersedia");
  }

  // =====================================================
  // DELETE ACCOUNT
  // =====================================================
  void deleteAccount() {
    Get.defaultDialog(
      title: "Hapus Akun",
      middleText: "Yakin ingin menghapus akun?",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.snackbar("Info", "Fitur belum tersedia");
      },
    );
  }

  // =====================================================
  // LOGOUT
  // =====================================================
  Future<void> logout() async {
    await box.erase();
    Get.offAllNamed(Routes.LOGIN);
  }

  // =====================================================
  // BACK
  // =====================================================
  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    unitController.dispose();
    super.onClose();
  }

  final otpController = TextEditingController();

Future<void> requestOtp(String email) async {
  await http.post(
    Uri.parse("${ApiEndpoint.baseUrl}/otp/send"),
    body: jsonEncode({"email": email}),
    headers: {"Content-Type": "application/json"},
  );
}

Future<bool> verifyOtp(String email, String otp) async {
  final res = await http.post(
    Uri.parse("${ApiEndpoint.baseUrl}/otp/verify"),
    body: jsonEncode({"email": email, "otp": otp}),
    headers: {"Content-Type": "application/json"},
  );

  return res.statusCode == 200;
}
}


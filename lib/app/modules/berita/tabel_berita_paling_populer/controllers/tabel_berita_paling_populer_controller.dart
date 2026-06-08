import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';

class TabelBeritaPalingPopulerController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  final RxList<Map<String, dynamic>> beritaList =
      <Map<String, dynamic>>[].obs;

  final RxString searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getBeritaPopuler();
  }

  Future<void> getBeritaPopuler() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = SessionManager.getToken();

      final response = await http.get(
        Uri.parse(ApiEndpoint.beritaPopuler),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        errorMessage.value =
            "HTTP Error ${response.statusCode}";
        return;
      }

      final body = jsonDecode(response.body);

      if (body["success"] != true) {
        errorMessage.value =
            body["message"] ?? "Gagal memuat data";
        return;
      }

      final List<dynamic> data = body["data"] ?? [];

      beritaList.assignAll(
        data.map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await getBeritaPopuler();
  }

  void updateSearch(String value) {
    searchKeyword.value = value;
  }

  List<Map<String, dynamic>> get filteredBerita {
    if (searchKeyword.value.isEmpty) {
      return beritaList;
    }

    return beritaList.where((item) {
      final judul =
          item["judul"]
              ?.toString()
              .toLowerCase() ??
          '';

      final ringkasan =
          item["ringkasan"]
              ?.toString()
              .toLowerCase() ??
          '';

      final keyword =
          searchKeyword.value.toLowerCase();

      return judul.contains(keyword) ||
          ringkasan.contains(keyword);
    }).toList();
  }

  Map<String, dynamic>? get beritaTerpopuler {
    if (beritaList.isEmpty) {
      return null;
    }

    return beritaList.first;
  }

  int get totalBerita {
    return beritaList.length;
  }

  int get totalDilihat {
    int total = 0;

    for (final item in beritaList) {
      total +=
          ((item["total_dilihat"] ?? 0) as num)
              .toInt();
    }

    return total;
  }

  String get namaUser {
    return SessionManager.fullname;
  }

  String get username {
    return SessionManager.username;
  }

  String get province {
    return SessionManager.province;
  }

  String get image {
    return SessionManager.image;
  }

  int get points {
    return SessionManager.points;
  }

  bool get isLoggedIn {
    return SessionManager.isLoggedIn;
  }
}
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';

class TabelBeritaProvinsiController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  final RxList<Map<String, dynamic>> provinsiList =
      <Map<String, dynamic>>[].obs;

  final RxInt totalBerita = 0.obs;

  final RxString searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getDataProvinsi();
  }

  Future<void> getDataProvinsi() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = SessionManager.getToken();

      final response = await http.get(
        Uri.parse(ApiEndpoint.beritaProvinsi),
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

      final List<dynamic> data =
          body["data"] ?? [];

      provinsiList.assignAll(
        data.map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );

      int total = 0;

      for (final item in provinsiList) {
        total +=
            ((item["jumlah_berita"] ?? 0) as num)
                .toInt();
      }

      totalBerita.value = total;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await getDataProvinsi();
  }

  void updateSearch(String value) {
    searchKeyword.value = value;
  }

  List<Map<String, dynamic>> get filteredProvinsi {
    if (searchKeyword.value.isEmpty) {
      return provinsiList;
    }

    return provinsiList.where((item) {
      final provinsi =
          item["provinsi"]
              ?.toString()
              .toLowerCase() ??
          '';

      return provinsi.contains(
        searchKeyword.value.toLowerCase(),
      );
    }).toList();
  }

  Map<String, dynamic>? get provinsiTeratas {
    if (provinsiList.isEmpty) {
      return null;
    }

    return provinsiList.first;
  }

  int get jumlahProvinsi {
    return provinsiList.length;
  }

  String get namaUser {
    return SessionManager.fullname;
  }

  String get username {
    return SessionManager.username;
  }

  String get userProvince {
    return SessionManager.province;
  }

  String get profileImage {
    return SessionManager.image;
  }

  int get userPoints {
    return SessionManager.points;
  }

  bool get isLoggedIn {
    return SessionManager.isLoggedIn;
  }
}
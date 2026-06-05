import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';

class LeaderboardController extends GetxController {
  // ==============================================
  // KATEGORI & TAB
  // ==============================================
  final List<String> categories = [
    'Global',
    'Provinsi', // Kategori Provinsi ditambahkan
    'Sandi Kotak 1',
    'Sandi Kotak 2',
    'Morse'
  ];
  final selectedCategory = 'Global'.obs;

  final Map<String, String> categoryToGameId = {
    'Sandi Kotak 1': 'sandi_kotak_1',
    'Sandi Kotak 2': 'sandi_kotak_2',
    'Morse': 'morse_challenge',
  };

  // ==============================================
  // OBSERVABLES - DATA USER LOGIN SAAT INI
  // ==============================================
  final isLoading = false.obs;
  
  final myPoint = 0.obs;
  final myRank = 0.obs;
  final myName = "".obs;
  final myEmail = "".obs;
  final myImage = "".obs;
  final myProvince = "".obs;

  // ==============================================
  // OBSERVABLES - LIST LEADERBOARD
  // ==============================================
  final leaderboard = <Map<String, dynamic>>[].obs;
  final topThree = <Map<String, dynamic>>[].obs;
  final otherRanksList = <Map<String, dynamic>>[].obs;

  // ==============================================
  // OBSERVABLES - DETAIL PESERTA (BOTTOM SHEET)
  // ==============================================
  final participantDetailLoading = false.obs;
  // Menyimpan stat untuk: Global, Sandi Kotak 1, Sandi Kotak 2, Morse
  final participantDetailStats = <String, Map<String, int>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null && Get.arguments['game_name'] != null) {
      String passedCategory = Get.arguments['game_name'];
      if (categories.contains(passedCategory)) {
        selectedCategory.value = passedCategory;
      }
    }
    
    getLeaderboard();
  }

  // ==============================================
  // ACTION METHODS
  // ==============================================
  void changeCategory(String newCategory) {
    if (selectedCategory.value != newCategory) {
      selectedCategory.value = newCategory;
      getLeaderboard(); 
    }
  }

  // ==============================================
  // FETCH LEADERBOARD UTAMA
  // ==============================================
  Future<void> getLeaderboard() async {
    try {
      isLoading.value = true;
      _clearData();

      // 1. AMBIL DATA LOGIN DARI SESSION MANAGER
      final token = SessionManager.getToken();
      
      myEmail.value = SessionManager.email;
      myName.value = SessionManager.fullname.isNotEmpty ? SessionManager.fullname : 'Scout';
      myImage.value = SessionManager.image.isNotEmpty ? SessionManager.image : 'default_profile.png';
      myProvince.value = SessionManager.province.isNotEmpty ? SessionManager.province : '-';

      String url = ApiEndpoint.leaderboard; 
      
      // Jika kategori Provinsi, kita tetap panggil endpoint Global
      if (selectedCategory.value != 'Global' && selectedCategory.value != 'Provinsi') {
        String gameId = categoryToGameId[selectedCategory.value] ?? '';
        url = "${ApiEndpoint.gameScore}?game_name=$gameId"; 
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.body.isEmpty) throw Exception("Response kosong");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> usersData = result["data"] ?? [];

        if (usersData.isEmpty) {
          myRank.value = 0;
          myPoint.value = 0;
          return;
        }

        // =========================================================
        // LOGIKA KHUSUS UNTUK KATEGORI PROVINSI
        // =========================================================
        if (selectedCategory.value == 'Provinsi') {
          Map<String, int> provData = {};
          
          // Agregasi (jumlahkan) poin berdasarkan nama provinsi
          for (var item in usersData) {
            String prov = item["province"]?.toString().trim() ?? "";
            if (prov.isEmpty || prov == "-") prov = "Lainnya";
            int point = int.tryParse(item["points"]?.toString() ?? "0") ?? 0;
            provData[prov] = (provData[prov] ?? 0) + point;
          }

          // Ubah map jadi list untuk UI
          List<Map<String, dynamic>> provList = provData.entries.map((e) => {
            "name": e.key,
            "point": e.value,
            "email": "",
            "province": "Provinsi", 
            "image": "", 
            "isProvince": true, // Penanda agar UI tau ini data provinsi
          }).toList();

          // Urutkan dan beri rank
          provList.sort((a, b) => (b["point"] as int).compareTo(a["point"] as int));
          for(int i = 0; i < provList.length; i++) {
            provList[i]["rank"] = i + 1;
          }

          _distributeDataToLists(provList);

          // Cari rank provinsi milik user yang login
          final myProvName = myProvince.value.trim().isEmpty || myProvince.value == "-" 
              ? "Lainnya" : myProvince.value.trim();
          final myIndex = provList.indexWhere((p) => p["name"].toString().toLowerCase() == myProvName.toLowerCase());

          if (myIndex != -1) {
            myRank.value = provList[myIndex]["rank"];
            myPoint.value = provList[myIndex]["point"];
          } else {
            myRank.value = 0;
            myPoint.value = 0;
          }
          return; // Selesai untuk logika provinsi, keluar dari fungsi
        }

        // =========================================================
        // LOGIKA NORMAL UNTUK GLOBAL & GAME SPESIFIK
        // =========================================================
        final List<Map<String, dynamic>> normalizedUsers = [];
        
        for (var item in usersData) {
          int point = 0;
          String name = "-";
          String email = "";
          String province = "-";
          String image = "";

          if (selectedCategory.value == 'Global') {
            point = int.tryParse(item["points"]?.toString() ?? "0") ?? 0;
            name = item["fullname"] ?? "-";
            email = item["email"] ?? "";
            province = item["province"] ?? "-";
            image = item["image"] ?? "";
          } else {
            point = int.tryParse(item["score"]?.toString() ?? "0") ?? 0;
            final userData = item["users"];
            if (userData != null) {
              name = userData["fullname"] ?? "-";
              email = userData["email"] ?? "";
              province = userData["province"] ?? "-";
              image = userData["image"] ?? "";
            }
          }

          normalizedUsers.add({
            "name": name,
            "email": email,
            "province": province,
            "point": point,
            "image": image,
            "isProvince": false, // Penanda untuk UI
          });
        }

        normalizedUsers.sort((a, b) => (b["point"] as int).compareTo(a["point"] as int));

        final List<Map<String, dynamic>> rankedUsers = [];
        for (int i = 0; i < normalizedUsers.length; i++) {
          var user = normalizedUsers[i];
          user["rank"] = i + 1;
          rankedUsers.add(user);
        }

        _distributeDataToLists(rankedUsers);

        final targetEmail = myEmail.value.trim().toLowerCase();
        final myIndex = rankedUsers.indexWhere(
          (user) => user["email"].toString().trim().toLowerCase() == targetEmail,
        );

        if (myIndex != -1) {
          myRank.value = rankedUsers[myIndex]["rank"];
          myPoint.value = rankedUsers[myIndex]["point"];
        } else {
          myRank.value = 0;
          myPoint.value = 0;
        }

      } else {
        Get.snackbar("Oops!", result["message"] ?? "Gagal memuat data", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Koneksi Bermasalah", "Gagal terhubung ke server.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi helper untuk membagi list ke observabels UI
  void _distributeDataToLists(List<Map<String, dynamic>> listData) {
    leaderboard.assignAll(listData);
    topThree.assignAll(listData.take(3).toList());
    if (listData.length > 3) {
      otherRanksList.assignAll(listData.sublist(3));
    } else {
      otherRanksList.clear();
    }
  }

  // ==============================================
  // FETCH DATA DETAIL PESERTA (SEMUA KATEGORI)
  // ==============================================
  Future<void> loadParticipantStats(String targetEmail) async {
    participantDetailLoading.value = true;
    
    // Inisialisasi default stats (0)
    Map<String, Map<String, int>> stats = {
      'Global': {'rank': 0, 'point': 0},
      'Sandi Kotak 1': {'rank': 0, 'point': 0},
      'Sandi Kotak 2': {'rank': 0, 'point': 0},
      'Morse': {'rank': 0, 'point': 0},
    };
    participantDetailStats.value = stats;

    try {
      final token = SessionManager.getToken();
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      // Jalankan 4 Request Sekaligus (Paralel)
      final responses = await Future.wait([
        http.get(Uri.parse(ApiEndpoint.leaderboard), headers: headers),
        http.get(Uri.parse("${ApiEndpoint.gameScore}?game_name=${categoryToGameId['Sandi Kotak 1']}"), headers: headers),
        http.get(Uri.parse("${ApiEndpoint.gameScore}?game_name=${categoryToGameId['Sandi Kotak 2']}"), headers: headers),
        http.get(Uri.parse("${ApiEndpoint.gameScore}?game_name=${categoryToGameId['Morse']}"), headers: headers),
      ]);

      // Fungsi Helper untuk Parsing dan Cari Rank
      void parseAndFind(http.Response res, String key, bool isGlobal) {
        if (res.statusCode == 200) {
          final result = jsonDecode(res.body);
          final List<dynamic> users = result["data"] ?? [];
          
          final List<Map<String, dynamic>> normalized = [];
          for (var item in users) {
            int pt = 0;
            String em = "";
            if (isGlobal) {
              pt = int.tryParse(item["points"]?.toString() ?? "0") ?? 0;
              em = item["email"]?.toString() ?? "";
            } else {
              pt = int.tryParse(item["score"]?.toString() ?? "0") ?? 0;
              final uData = item["users"];
              if (uData != null) em = uData["email"]?.toString() ?? "";
            }
            normalized.add({"email": em, "point": pt});
          }
          
          normalized.sort((a, b) => (b["point"] as int).compareTo(a["point"] as int));
          
          // Cari email target dengan aman
          final safeTargetEmail = targetEmail.trim().toLowerCase();
          for (int i = 0; i < normalized.length; i++) {
            if (normalized[i]["email"].toString().trim().toLowerCase() == safeTargetEmail) {
              stats[key] = {'rank': i + 1, 'point': normalized[i]["point"]};
              break;
            }
          }
        }
      }

      parseAndFind(responses[0], 'Global', true);
      parseAndFind(responses[1], 'Sandi Kotak 1', false);
      parseAndFind(responses[2], 'Sandi Kotak 2', false);
      parseAndFind(responses[3], 'Morse', false);

      participantDetailStats.value = Map.from(stats); // Update state

    } catch (e) {
      print("Gagal mengambil detail stat: $e");
    } finally {
      participantDetailLoading.value = false;
    }
  }

  void _clearData() {
    leaderboard.clear();
    topThree.clear();
    otherRanksList.clear();
  }
}       
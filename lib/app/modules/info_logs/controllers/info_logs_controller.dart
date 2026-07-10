import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '..../../../../data/api_endpoint.dart';

class InfoLogsController extends GetxController {
  final GetStorage box = GetStorage();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Data asli dari API
  final _allLogs = <dynamic>[].obs;
  
  // Data yang akan ditampilkan di UI (setelah difilter)
  var logs = <dynamic>[].obs;

  // ==================== FILTER STATE ====================
  // '7hari' atau 'semua'
  var timeFilter = '7hari'.obs;
  
  // 'Semua' atau kategori spesifik
  var categoryFilter = 'Semua Kategori'.obs;
  
  // Daftar kategori unik yang diambil dinamis dari data
  var availableCategories = <String>['Semua Kategori'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = box.read("token");

      if (token == null || token.toString().isEmpty) {
        errorMessage.value = 'Sesi telah habis, silakan login kembali.';
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoint.infoLogs),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        List rawData = result["data"] ?? result["logs"] ?? [];
        
        _allLogs.value = rawData;
        _extractCategories(rawData);
        applyFilters(); // Terapkan filter default (7 Hari & Semua Kategori)

      } else {
        errorMessage.value = 'Gagal memuat log aktivitas (Kode: ${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan jaringan atau server.';
      debugPrint("FETCH LOGS ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== FILTERING LOGIC ====================

  void setTimeFilter(String value) {
    timeFilter.value = value;
    applyFilters();
  }

  void setCategoryFilter(String value) {
    categoryFilter.value = value;
    applyFilters();
  }

  void _extractCategories(List data) {
    Set<String> categories = {'Semua Kategori'};
    for (var log in data) {
      // Kita asumsikan kategori bisa diambil dari kata pertama pada 'activity'
      // Jika di DB ada kolom 'category' khusus, gunakan: log['category']
      String activity = log['activity']?.toString() ?? 'Lainnya';
      String category = activity.split(' ').first; // Ambil kata pertama sbg kategori
      if (category.isNotEmpty) {
        categories.add(category);
      }
    }
    availableCategories.value = categories.toList();
  }

  void applyFilters() {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));

    List<dynamic> filtered = _allLogs.where((log) {
      // 1. Cek Waktu
      bool passTime = true;
      if (timeFilter.value == '7hari' && log['created_at'] != null) {
        try {
          DateTime logDate = DateTime.parse(log['created_at']).toLocal();
          passTime = logDate.isAfter(sevenDaysAgo) || logDate.isAtSameMomentAs(sevenDaysAgo);
        } catch (e) {
          passTime = true; // Jika gagal parse, anggap masuk filter
        }
      }

      // 2. Cek Kategori
      bool passCategory = true;
      if (categoryFilter.value != 'Semua Kategori') {
        String activity = log['activity']?.toString() ?? '';
        passCategory = activity.startsWith(categoryFilter.value);
      }

      return passTime && passCategory;
    }).toList();

    logs.value = filtered;
  }

  Future<void> refreshLogs() async {
    await fetchLogs();
  }
}
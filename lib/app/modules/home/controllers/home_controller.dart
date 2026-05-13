import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:scoutify/app/modules/home/views/home_view.dart';
// Import halaman-halaman kamu di sini
// import '../modules/edukasi/edukasi_view.dart';
import '../../edukasi/beranda_edukasi/views/beranda_edukasi_view.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  // 1. DAFTAR HALAMAN UNTUK BODY
  // Ini yang menentukan apa yang muncul saat tombol BottomNav ditekan
  final List<Widget> pages = [
    const HomeView(), // Isi konten Dashboard/Beranda kamu
    const BerandaEdukasiView(),       // Halaman Edukasi yang barusan dibuat
    const Center(child: Text("Halaman Game")),
    const Center(child: Text("Halaman Alat")),
    const Center(child: Text("Halaman Profil")),
  ];

  void changeIndex(int index) => selectedIndex.value = index;

  // 2. DATA MENU GRID (Tetap ada untuk konten di halaman Beranda)
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Morse", "icon": Icons.graphic_eq, "color": 0xFFFFCA98},
    {"title": "Tali Temali", "icon": Icons.link, "color": 0xFFFFDBCF},
    {"title": "Survival", "icon": Icons.terrain, "color": 0xFFFFDAD2},
    {"title": "Semaphore", "icon": Icons.flag, "color": 0xFFFFDCBD},
    {"title": "Sandi", "icon": Icons.vpn_key, "color": 0xFFE5E2DD},
    {"title": "Sejarah", "icon": Icons.history_edu, "color": 0xFFE5E2DD},
    {"title": "Dasar", "icon": Icons.school, "color": 0xFFFFCA98},
    {"title": "Gudep", "icon": Icons.tag, "color": 0xFFFFDBCF},
  ];
}
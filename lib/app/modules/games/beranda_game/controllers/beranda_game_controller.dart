import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BerandaGameController extends GetxController {
  // Data untuk Kuis Sandi
  final List<Map<String, dynamic>> quizItems = [
    {
      "title": "Tebak Sandi Kotak 1",
      "desc": "Uji kecepatanmu menerjemahkan simbol kotak klasik!",
      "icon": Icons.grid_view_rounded,
    },
    {
      "title": "Tebak Sandi Kotak 2",
      "desc": "Lebih menantang dengan pola kotak yang lebih kompleks.",
      "icon": Icons.apps_rounded,
    },
    {
      "title": "Tebak Sandi Morse",
      "desc": "Dengarkan dan tebak kode morse dengan tepat.",
      "icon": Icons.graphic_eq_rounded,
    },
  ];

  void startSemaphore() => print("Mulai Deteksi Semaphore");
  
  void openLeaderboard() => print("Membuka Papan Peringkat");

  void playQuiz(String title) => print("Memainkan kuis: $title");
}
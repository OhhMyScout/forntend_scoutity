import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarController extends GetxController {
  var index = 0.obs;

  final pages = [
    '/home',
    '/beranda-edukasi',
    '/beranda-game',
    '/beranda-survival',
    '/beranda-profile',
  ];

  void changeTab(int i) {
    index.value = i;
    Get.offAllNamed(pages[i]);
  }
}

class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabBarController(), permanent: true);

    const primary = Color(0xFF361F1A);

    return Obx(() => BottomNavigationBar(
          currentIndex: controller.index.value,
          onTap: controller.changeTab,
          selectedItemColor: primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: "Edukasi",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports_rounded),
              label: "Game",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_rounded),
              label: "Survival",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Profil",
            ),
          ],
        ));
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

<<<<<<< HEAD
import '../../routes/app_pages.dart';

=======
>>>>>>> 71dd7caa84086dfcb2feeeed48b5b278fa81020f
class TabBarController extends GetxController {
  var index = 0.obs;

  final pages = [
<<<<<<< HEAD
    Routes.HOME,
    Routes.BERANDA_EDUKASI,
    Routes.BERANDA_GAME,
    Routes.BERANDA_SURVIVAL,
    Routes.BERANDA_PROFILE,
=======
    '/home',
    '/beranda-edukasi',
    '/beranda-game',
    '/beranda-survival',
    '/beranda-profile',
>>>>>>> 71dd7caa84086dfcb2feeeed48b5b278fa81020f
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
// lib/app/modules/theme/tabbar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTabBar extends StatelessWidget {
  final int currentIndex;

  const AppTabBar({
    super.key,
    required this.currentIndex,
  });

  static const Color primary = Color(0xff361F1A);

  final List<String> pages = const [
    '/home',
    '/beranda-edukasi',
    '/beranda-game',
    '/beranda-survival',
    '/beranda-profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 88,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffF0EDE9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              index: 0,
              icon: Icons.home,
              label: "Home",
            ),

            _navItem(
              index: 1,
              icon: Icons.school,
              label: "Education",
            ),

            _navItem(
              index: 2,
              icon: Icons.sports_esports,
              label: "Games",
            ),

            _navItem(
              index: 3,
              icon: Icons.forest,
              label: "Survival",
            ),

            _navItem(
              index: 4,
              icon: Icons.person,
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool selected =
        currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (Get.currentRoute !=
            pages[index]) {
          Get.offNamed(pages[index]);
        }
      },

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 250),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: selected
              ? const Color(0xff4E342E)
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(100),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected
                  ? const Color(0xffC19C94)
                  : const Color(0xff504442),
            ),

            const SizedBox(height: 2),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w600,
                color: selected
                    ? const Color(0xffC19C94)
                    : const Color(0xff504442),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
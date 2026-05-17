// lib/app/modules/theme/tabbar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTabBar extends StatelessWidget {
  final int currentIndex;

  const AppTabBar({
    super.key,
    required this.currentIndex,
  });

  static const Color primary = Color.fromARGB(255, 54, 31, 26);

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
        height: 76,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(219, 87, 44, 1),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              // Perbaikan warning deprecated: Menggunakan .withValues
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(
              index: 0,
              icon: Icons.home_rounded,
              label: "Home",
            ),
            _navItem(
              index: 1,
              icon: Icons.school_rounded,
              label: "Education",
            ),
            _navItem(
              index: 2,
              icon: Icons.sports_esports_rounded,
              label: "Games",
            ),
            _navItem(
              index: 3,
              icon: Icons.forest_rounded,
              label: "Survival",
            ),
            _navItem(
              index: 4,
              icon: Icons.person_rounded,
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
    final bool selected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (Get.currentRoute != pages[index]) {
          // Perbaikan error parameter: Panggilan rute named yang valid dan aman
          Get.offNamed(pages[index]);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color.fromARGB(255, 255, 255, 255) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? const Color.fromARGB(219, 87, 44, 1) : const Color.fromARGB(255, 255, 255, 255),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                child: selected
                    ? Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(219, 87, 44, 1),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
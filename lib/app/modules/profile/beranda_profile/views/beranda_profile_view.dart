import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../../../theme/tabbar.dart';
import '../controllers/beranda_profile_controller.dart';

class BerandaProfileView extends GetView<BerandaProfileController> {
  const BerandaProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await controller.refreshProfile();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 120,
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildProfileSection(),
                    const SizedBox(height: 32),
                    _buildInfoSection(),
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: AppTabBar(currentIndex: 4),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  Widget _buildHeader() {
    return SizedBox(
      height: 60,
      child: Center(
        child: Text(
          "Profil",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  // =====================================================
  Widget _buildProfileSection() {
    return Obx(
      () => Column(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: AppTheme.primary,
            child: Text(
              (controller.user["fullname"] ?? "U")
                      .toString()
                      .trim()
                      .isNotEmpty
                  ? controller.user["fullname"][0].toUpperCase()
                  : "U",
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            controller.user["fullname"] ?? "-",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 8),

          Text(
            controller.user["email"] ?? "-",
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              controller.user["role"] ?? "-",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  Widget _buildInfoSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              "Informasi Akun",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                fontFamily: "Poppins",
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF0EDE9)),
            ),
            child: Column(
              children: [
                _buildInfoTile(
                  icon: Icons.person,
                  title: "Username",
                  value: controller.user["username"] ?? "-",
                  showBorder: true,
                ),

                _buildInfoTile(
                  icon: Icons.apartment,
                  title: "Gudep",
                  value: controller.user["gudep"] ?? "-",
                  showBorder: true,
                ),

                _buildInfoTile(
                  icon: Icons.email,
                  title: "Email",
                  value: controller.user["email"] ?? "-",
                  showBorder: true,
                ),

                _buildInfoTile(
                  icon: Icons.map,
                  title: "Provinsi",
                  value: controller.user["province"] ?? "-",
                  showBorder: true,
                ),

                _buildInfoTile(
                  icon: Icons.security,
                  title: "Role",
                  value: controller.user["role"] ?? "-",
                  showBorder: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required bool showBorder,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(bottom: BorderSide(color: Color(0xFFF6F3EE)))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFF0EDE9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.secondary),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Get.toNamed('/edit-profile');
            },
            icon: const Icon(Icons.edit),
            label: const Text(
              "Edit Profil",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 58,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.onSurfaceVariant,
              side: const BorderSide(color: Color(0xFFD4C3BF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Get.toNamed('/settings');
            },
            icon: const Icon(Icons.settings),
            label: const Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFFDAD6).withValues(alpha: 0.3),
                      foregroundColor: const Color(0xFF93000A),
                    ),
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Keluar Akun?",
                        middleText: "Apakah Anda yakin ingin logout?",
                        textConfirm: "Logout",
                        textCancel: "Batal",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          Get.back();
                          controller.logout();
                        },
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      "Keluar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
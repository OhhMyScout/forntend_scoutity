// lib/app/modules/profile/beranda_profile/views/beranda_profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../../../theme/tabbar.dart';
import '../controllers/beranda_profile_controller.dart';

class BerandaProfileView
    extends GetView<BerandaProfileController> {
  const BerandaProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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

            Align(
              alignment: Alignment.bottomCenter,
              child: AppTabBar(
                currentIndex: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildProfileSection() {
    return Obx(
      () => Column(
        children: [
          Stack(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.1,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    controller.user["image"]
                        .toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            controller.user["name"].toString(),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 8),

          Text(
            controller.user["email"].toString(),
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0xFFFFCA98,
              ).withValues(alpha: 0.3),
              borderRadius:
                  BorderRadius.circular(
                100,
              ),
              border: Border.all(
                color: const Color(
                  0xFFFFCA98,
                ).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.stars,
                  color: AppTheme.secondary,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Text(
                  controller.user["points"]
                      .toString(),
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color: Color(
                      0xFF7A532A,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color: const Color(
                0xFFF0EDE9,
              ),
            ),
          ),

          child: Column(
            children: [
              _buildInfoTile(
                icon: Icons.map,
                title: "Provinsi",
                value: controller
                    .user["province"]
                    .toString(),
                showBorder: true,
              ),

              _buildInfoTile(
                icon: Icons.groups,
                title: "Gugus Depan",
                value: controller
                    .user["gudep"]
                    .toString(),
                showBorder: true,
              ),

              _buildInfoTile(
                icon:
                    Icons.calendar_today,
                title:
                    "Tanggal Bergabung",
                value: controller
                    .user["joined"]
                    .toString(),
                showBorder: false,
              ),
            ],
          ),
        ),
      ],
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
            ? const Border(
                bottom: BorderSide(
                  color: Color(
                    0xFFF6F3EE,
                  ),
                ),
              )
            : null,
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(
                0xFFF0EDE9,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.secondary,
            ),
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color:
                      AppTheme
                          .onSurfaceVariant,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppTheme.primary,
                ),
              ),
            ],
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
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  AppTheme.primary,
              foregroundColor:
                  Colors.white,
              elevation: 2,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
            ),
            onPressed: () {},
            icon: const Icon(
              Icons.person,
            ),
            label: const Text(
              "Edit Profile",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 58,
          child: OutlinedButton.icon(
            style:
                OutlinedButton.styleFrom(
              backgroundColor:
                  Colors.white,
              foregroundColor:
                  AppTheme
                      .onSurfaceVariant,
              side: const BorderSide(
                color: Color(
                  0xFFD4C3BF,
                ),
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
            ),
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
            ),
            label: const Text(
              "Settings",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                0xFFFFDAD6,
              ).withValues(alpha: 0.3),
              foregroundColor:
                  const Color(
                0xFF93000A,
              ),
              elevation: 0,
              side: BorderSide(
                color: const Color(
                  0xFFFFDAD6,
                ).withValues(alpha: 0.5),
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
            ),
            onPressed: () => controller.logout(),
            icon: const Icon(
              Icons.logout,
            ),
            label: const Text(
              "Keluar",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
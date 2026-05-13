import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);
    const backgroundColor = Color(0xFFFCF9F4);
    const surfaceColor = Colors.white;
    const surfaceVariant = Color(0xFFE5E2DD);
    const textSecondary = Color(0xFF504442);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PROFILE
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Row(
                children: [

                  /// IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB-w-30PH-szcBnVNbp6OXWtVUOeVoXtgRV6OxYA0bDyqVup-irW6PkWqzH-SJ-GEyLH4whz-8SgU7LOHP77UhXwzlZIh4Kx2qDOm1S6TYQ6oKSHF987JcrAi71I7dB1_HRT3bOBCSsY7EbwBqgj1KexS4v5FxSInte5vG4cQTGw47y9MDLU9rMBWAtE7FKSVMyuBkymplp_fYijt42xG1NapS7-77QzDq-BjQZ81eZEnODqjU0tnD54nap1SRajii9wXtoaV72ZkU',
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// NAME
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budi Pramuka',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Pandu Tingkat Utama',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: controller.changeProfile,
                    child: const Text(
                      'Ubah Profil',
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// PERSONALISASI
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                'Personalisasi',
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                children: [

                  /// DARK MODE
                  Obx(
                    () => SwitchListTile(
                      value: controller.isDarkMode.value,
                      onChanged: controller.toggleTheme,
                      activeColor: secondaryColor,
                      title: const Text(
                        'Tema Gelap / Terang',
                      ),
                      secondary: const Icon(
                        Icons.dark_mode,
                        color: secondaryColor,
                      ),
                    ),
                  ),

                  Divider(
                    color: surfaceVariant,
                    height: 1,
                  ),

                  /// NOTIFICATION
                  Obx(
                    () => SwitchListTile(
                      value: controller.isNotificationActive.value,
                      onChanged: controller.toggleNotification,
                      activeColor: secondaryColor,
                      title: const Text(
                        'Nyalakan / Matikan Notifikasi',
                      ),
                      secondary: const Icon(
                        Icons.notifications_active,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// INFORMATION
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                'Informasi & Bantuan',
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                children: [

                  /// PRIVACY
                  ListTile(
                    onTap: controller.openPrivacyPolicy,

                    leading: const Icon(
                      Icons.gavel,
                      color: secondaryColor,
                    ),

                    title: const Text(
                      'Kebijakan & Privasi',
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),

                  Divider(
                    color: surfaceVariant,
                    height: 1,
                  ),

                  /// FEEDBACK
                  ListTile(
                    onTap: controller.sendFeedback,

                    leading: const Icon(
                      Icons.chat_bubble,
                      color: secondaryColor,
                    ),

                    title: const Text(
                      'Umpan Balik',
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// VERSION
            Column(
              children: [

                Icon(
                  Icons.explore,
                  size: 40,
                  color: primaryColor.withOpacity(0.2),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Versi Aplikasi 1.0.0',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],  
            ),
          ],
        ),
      ),
    );
  }
}
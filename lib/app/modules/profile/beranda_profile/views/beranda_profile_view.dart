import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../../../theme/tabbar.dart';
import '../controllers/beranda_profile_controller.dart';

class BerandaProfileView extends StatefulWidget {
  const BerandaProfileView({super.key});

  @override
  State<BerandaProfileView> createState() => _BerandaProfileViewState();
}

class _BerandaProfileViewState extends State<BerandaProfileView> with SingleTickerProviderStateMixin {
  final BerandaProfileController controller = Get.find<BerandaProfileController>();

  // Setup Animasi Staggered
  late AnimationController _animationController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _profileFade;
  late Animation<double> _profileScale;
  late Animation<double> _infoFade;
  late Animation<Offset> _infoSlide;
  late Animation<double> _googleFade;
  late Animation<Offset> _googleSlide;
  late Animation<double> _actionFade;
  late Animation<Offset> _actionSlide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // 1. Header Animasi (0.0 - 0.3)
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic)));
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic)));

    // 2. Profile Avatar & Name (0.2 - 0.5)
    _profileFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic)));
    _profileScale = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.5, curve: Curves.easeOutBack)));

    // 3. Info Section (0.4 - 0.7)
    _infoFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic)));
    _infoSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic)));

    // 4. Google Connect Section (0.6 - 0.8)
    _googleFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.6, 0.8, curve: Curves.easeOutCubic)));
    _googleSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.6, 0.8, curve: Curves.easeOutCubic)));

    // 5. Action Buttons (0.7 - 1.0)
    _actionFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic)));
    _actionSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic)));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Background super soft
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppTheme.primary,
              onRefresh: () async {
                await controller.refreshProfile();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
                child: Column(
                  children: [
                    // Header
                    FadeTransition(
                      opacity: _headerFade,
                      child: SlideTransition(position: _headerSlide, child: _buildHeader()),
                    ),
                    const SizedBox(height: 24),
                    
                    // Profile Section
                    FadeTransition(
                      opacity: _profileFade,
                      child: ScaleTransition(scale: _profileScale, child: _buildProfileSection()),
                    ),
                    const SizedBox(height: 32),
                    
                    // Info Section
                    FadeTransition(
                      opacity: _infoFade,
                      child: SlideTransition(position: _infoSlide, child: _buildInfoSection()),
                    ),
                    const SizedBox(height: 24),

                    // Google Account Section
                    FadeTransition(
                      opacity: _googleFade,
                      child: SlideTransition(position: _googleSlide, child: _buildGoogleSection()),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    FadeTransition(
                      opacity: _actionFade,
                      child: SlideTransition(position: _actionSlide, child: _buildActionButtons()),
                    ),
                  ],
                ),
              ),
            ),

            // TabBar Positioned
            const Align(
              alignment: Alignment.bottomCenter,
              child: AppTabBar(currentIndex: 4),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // Ganti Settings dengan History Icon (Log Aktivitas)
  // =====================================================
  Widget _buildHeader() {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Center(
            child: Text(
              "Profil",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
                fontFamily: "Poppins",
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
              child: IconButton(
                tooltip: "Log Aktivitas",
                icon: Icon(Icons.history_rounded, color: AppTheme.primary, size: 24),
                onPressed: () {
                  controller.goToInfoLogs();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Tambah Informasi Tanggal Bergabung (Joined Date)
  // =====================================================
  Widget _buildProfileSection() {
    return Obx(
      () => Column(
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primary,
              backgroundImage: (controller.user["image"] ?? "").toString().trim().isNotEmpty
                  ? NetworkImage(controller.user["image"].toString())
                  : null,
              child: (controller.user["image"] ?? "").toString().trim().isEmpty
                  ? Text(
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
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 20),

          // Name
          Text(
            controller.user["fullname"] ?? "-",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 4),

          // Email
          Text(
            controller.user["email"] ?? "-",
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // Role Badge & Join Date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                ),
                child: Text(
                  (controller.user["role"] ?? "-").toString().toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Tanggal Pertama Kali Dibuat
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month_rounded, size: 14, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 6),
              Text(
                "Bergabung sejak ${controller.user["joined"]}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
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
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              "Informasi Akun",
              style: TextStyle(
                fontSize: 18,
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
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoTile(
                  icon: Icons.person_outline_rounded,
                  title: "Username",
                  value: controller.user["username"] ?? "-",
                  showBorder: true,
                ),
                _buildInfoTile(
                  icon: Icons.apartment_rounded,
                  title: "Gudep",
                  value: controller.user["gudep"] ?? "-",
                  showBorder: true,
                ),
                _buildInfoTile(
                  icon: Icons.map_outlined,
                  title: "Provinsi",
                  value: controller.user["province"] ?? "-",
                  showBorder: true,
                ),
                _buildInfoTile(
                  icon: Icons.security_rounded,
                  title: "Role Akses",
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
        border: showBorder ? const Border(bottom: BorderSide(color: Color(0xFFF9FAFB))) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.secondary, size: 20),
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
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
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

  // =====================================================
  // KONEKSI GOOGLE (FUNGSIONAL DENGAN LOADING)
  // =====================================================
  Widget _buildGoogleSection() {
  return Obx(() {
    final bool isLinked = controller.user["google_linked"] ?? false;
    final String googleEmail =
        controller.user["google_email"]?.toString() ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            "Keamanan & Login",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontFamily: "Poppins",
            ),
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFF3F4F6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Logo Google
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/assets/google_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              /// Informasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Akun Google",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isLinked
                                ? const Color(0xFF10B981)
                                : const Color(0xFF9CA3AF),
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            isLinked
                                ? googleEmail
                                : "Belum Terhubung",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isLinked
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // const SizedBox(width: 12),

              // /// Tombol
              // SizedBox(
              //   height: 40,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       if (isLinked) {
              //         controller.unlinkGoogle();
              //       } else {
              //         controller.linkGoogle();
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       elevation: 0,
              //       backgroundColor: isLinked
              //           ? Colors.red.shade50
              //           : AppTheme.primary,
              //       foregroundColor: isLinked
              //           ? Colors.red
              //           : Colors.white,
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 18,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     child: Text(
              //       isLinked ? "Putuskan" : "Hubungkan",
              //       style: const TextStyle(
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  });
}


  // =====================================================
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: AppTheme.primary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Get.toNamed('/edit-profile');
            },
            icon: const Icon(Icons.edit_rounded, size: 20),
            label: const Text(
              "Edit Profil",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4B5563),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Get.toNamed('/settings');
            },
            icon: const Icon(Icons.settings_rounded, size: 20),
            label: const Text(
              "Pengaturan Aplikasi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Tombol Keluar dengan Popup Custom yang Menarik
        Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEF2F2),
                      foregroundColor: const Color(0xFFDC2626),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      _showCustomLogoutDialog();
                    },
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text(
                      "Keluar Akun",
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

  // ================= CUSTOM LOGOUT DIALOG =================
  void _showCustomLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Lingkaran Merah
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFEE2E2), width: 3),
                ),
                child: const Icon(
                  Icons.power_settings_new_rounded,
                  color: Color(0xFFDC2626),
                  size: 36,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                "Keluar Akun?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                  fontFamily: 'Poppins',
                ),
              ),
              
              const SizedBox(height: 12),
              
              const Text(
                "Apakah Anda yakin ingin keluar dari Scoutify? Anda harus login kembali untuk melanjutkan petualangan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: const Color(0xFF4B5563),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Batal",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: const Color(0xFFDC2626).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Get.back(); // Tutup dialog
                        controller.logout(); 
                      },
                      child: const Text(
                        "Ya, Keluar",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true, 
    );
  }
}
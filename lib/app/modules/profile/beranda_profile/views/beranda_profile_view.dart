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

  // Setup Animasi
  late AnimationController _animationController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _profileFade;
  late Animation<double> _profileScale;
  late Animation<double> _infoFade;
  late Animation<Offset> _infoSlide;
  late Animation<double> _actionFade;
  late Animation<Offset> _actionSlide;

  @override
  void initState() {
    super.initState();

    // Durasi animasi 1.2 detik
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 1. Header Animasi (0.0 - 0.4)
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic)),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic)),
    );

    // 2. Profile (Avatar & Nama) Animasi (0.2 - 0.6) - Menggunakan Scale/Zoom halus
    _profileFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic)),
    );
    _profileScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack)),
    );

    // 3. Info Section (Kotak Informasi) Animasi (0.4 - 0.8)
    _infoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic)),
    );
    _infoSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic)),
    );

    // 4. Action Buttons (Edit, Settings, Logout) Animasi (0.6 - 1.0)
    _actionFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic)),
    );
    _actionSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic)),
    );

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
      backgroundColor: AppTheme.background,
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
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 120, // Ruang untuk TabBar
                ),
                child: Column(
                  children: [
                    // Header
                    FadeTransition(
                      opacity: _headerFade,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: _buildHeader(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Profile Section
                    FadeTransition(
                      opacity: _profileFade,
                      child: ScaleTransition(
                        scale: _profileScale,
                        child: _buildProfileSection(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Info Section
                    FadeTransition(
                      opacity: _infoFade,
                      child: SlideTransition(
                        position: _infoSlide,
                        child: _buildInfoSection(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    FadeTransition(
                      opacity: _actionFade,
                      child: SlideTransition(
                        position: _actionSlide,
                        child: _buildActionButtons(),
                      ),
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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
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
          ),

          const SizedBox(height: 24),

          Text(
            controller.user["fullname"] ?? "-",
            textAlign: TextAlign.center,
            style: TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                fontSize: 20,
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
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
                  icon: Icons.email_outlined,
                  title: "Email",
                  value: controller.user["email"] ?? "-",
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
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFF6F3EE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.secondary, size: 22),
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
                  style: TextStyle(
                    fontSize: 15,
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
              foregroundColor: AppTheme.onSurfaceVariant,
              side: const BorderSide(color: Color(0xFFD4C3BF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Get.toNamed('/settings');
            },
            icon: const Icon(Icons.settings_rounded, size: 20),
            label: const Text(
              "Pengaturan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Tombol Keluar dengan Popup Custom yang Menarik
        Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF0F0),
                      foregroundColor: const Color(0xFFD32F2F),
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
          borderRadius: BorderRadius.circular(24),
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
                  color: const Color(0xFFFFF0F0),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFD6D6), width: 2),
                ),
                child: const Icon(
                  Icons.power_settings_new_rounded,
                  color: Color(0xFFD32F2F),
                  size: 36,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Judul
              Text(
                "Keluar Akun?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                  fontFamily: 'Poppins',
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Deskripsi
              const Text(
                "Apakah Anda yakin ingin keluar dari Scoutify? Anda harus login kembali untuk melanjutkan petualangan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6B5E5B),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Tombol Batal & Keluar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: AppTheme.onSurfaceVariant,
                        side: const BorderSide(color: Color(0xFFD4C3BF)),
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
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Get.back(); // Tutup dialog dulu
                        controller.logout(); // Panggil fungsi logout di controller
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
      barrierDismissible: true, // Bisa ditutup dengan tap di luar
    );
  }
}
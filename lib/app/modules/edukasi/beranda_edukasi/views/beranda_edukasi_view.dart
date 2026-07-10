import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../../../theme/tabbar.dart';
import '../controllers/beranda_edukasi_controller.dart';

class BerandaEdukasiView extends GetView<BerandaEdukasiController> {
  const BerandaEdukasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20, right: 20, top: 20, bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnimatedComponent(delay: 0, child: _buildAppBar()),
                  const SizedBox(height: 24),
                  
                  // _AnimatedComponent(delay: 100, child: _buildHeroBanner()),
                  // const SizedBox(height: 24),

                  // Box Papan Informasi Uji SKU
                  _AnimatedComponent(delay: 200, child: _buildSkuSection()),
                  const SizedBox(height: 32),

                  _AnimatedComponent(delay: 300, child: _buildSejarahSection()),
                  const SizedBox(height: 36),



                  _AnimatedComponent(delay: 400, child: _buildMateriSection()),
                  const SizedBox(height: 36),

                  _AnimatedComponent(delay: 500, child: _buildKarakterSection()),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: AppTabBar(currentIndex: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Edukasi",
            style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold,
              color: AppTheme.primary, fontFamily: "Poppins",
            ),
          ),
          // Tombol Topi Toga Interaktif
          Material(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showProfilePopup(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: const Icon(Icons.school_rounded, color: AppTheme.primary, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // POPUP LUCU PROFIL & PROGRESS SKU
  // =========================================================
  void _showProfilePopup() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar Lucu
              Container(
                height: 80, width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondaryContainer,
                  border: Border.all(color: AppTheme.secondary, width: 3),
                  image: controller.userImage.value.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(controller.userImage.value), 
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: controller.userImage.value.isEmpty 
                    ? const Icon(Icons.face_retouching_natural_rounded, size: 46, color: AppTheme.onSecondaryContainer)
                    : null,
              ),
              const SizedBox(height: 16),
              
              const Text(
                "Cilukba! Salam Pramuka! 🏕️",
                style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 18,
                  fontWeight: FontWeight.bold, color: AppTheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              Text(
                "${controller.userName.value} • ${controller.userRole.value.toUpperCase()}",
                style: const TextStyle(fontFamily: 'Urbanist', fontSize: 14, color: AppTheme.onSurfaceVariant),
              ),
              
              // Badge Poin
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 24),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0), // Jeruk muda
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.orange, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "${controller.userPoints.value} Poin Terkumpul",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ],
                ),
              ),

              const Divider(color: AppTheme.surfaceContainerHighest),
              const SizedBox(height: 12),
              
              const Text(
                "Bocoran Progress SKU Kamu 🤫",
                style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.outlineColor),
              ),
              const SizedBox(height: 16),

              // Obx untuk memantau nilai loading/progress dari API
              Obx(() {
                if (controller.isLoadingProgress.value) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: AppTheme.secondary),
                  );
                }
                return Column(
                  children: [
                    _buildMiniProgress("Ramu", controller.progressRamu.value),
                    const SizedBox(height: 10),
                    _buildMiniProgress("Rakit", controller.progressRakit.value),
                    const SizedBox(height: 10),
                    _buildMiniProgress("Terap", controller.progressTerap.value),
                  ],
                );
              }),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Siapp, Tutup! 🫡", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
      // Membuat transisi masuk dialog menjadi bounce (memantul)
      transitionCurve: Curves.bounceOut,
    );
  }

  Widget _buildMiniProgress(String label, double progress) {
    int percent = (progress * 100).toInt();
    if (percent > 100) percent = 100;
    
    return Row(
      children: [
        SizedBox(
          width: 50, 
          child: Text(label, style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppTheme.primary)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surfaceContainerHighest,
              color: AppTheme.secondary,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 35,
          child: Text("$percent%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.secondary)),
        )
      ],
    );
  }
  // =========================================================

  // Widget _buildHeroBanner() {
  //   return Container(
  //     height: 180, width: double.infinity, padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF4E342E),
  //       borderRadius: BorderRadius.circular(28),
  //     ),
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           right: -20, top: -20,
  //           child: Icon(Icons.school_rounded, size: 130, color: Colors.white.withOpacity(0.08)),
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: const [
  //             Text(
  //               "Pusat Belajar Pramuka",
  //               style: TextStyle(
  //                 fontSize: 24, fontWeight: FontWeight.bold,
  //                 color: Colors.white, fontFamily: "Poppins",
  //               ),
  //             ),
  //             SizedBox(height: 8),
  //             Text(
  //               "Tingkatkan wawasan dan keterampilan kepramukaanmu.",
  //               style: TextStyle(color: Color(0xFFE5BEB5), fontSize: 14),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  

  Widget _buildSejarahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Container(
                height: 220, 
                width: double.infinity, 
                color: AppTheme.outlineVariantColor,
                child: Image.network(
                  "https://sipjkdlfjzmxptldxgxa.supabase.co/storage/v1/object/public/images/Gemini_Generated_Image_xt9qxqxt9qxqxt9q.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.history_edu_rounded, size: 80, color: Colors.white),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter, 
                      end: Alignment.topCenter, 
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Sejarah Kepramukaan", 
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            color: AppTheme.primary, 
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Berawal dari gagasan Lord Baden-Powell di Inggris, gerakan Kepramukaan telah menyebar ke seluruh penjuru dunia termasuk Indonesia.",
          style: TextStyle(height: 1.7, color: AppTheme.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        
        // ==========================================
        // TOMBOL BARU: 3D, Interaktif, dan Menarik
        // ==========================================
        Bouncy3DReadMoreButton(
          onTap: controller.openSejarah,
        ),
        // ==========================================
      ],
    );
  }

Widget _buildSkuSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.secondary, Color(0xFF9E713E)],
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withValues(alpha: 0.3), 
            blurRadius: 10, 
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2), 
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_turned_in_rounded, 
              color: Colors.white, 
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ujian Syarat Kecakapan",
                  style: TextStyle(
                    fontFamily: 'Poppins', 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Uji kecakapanmu, ajukan validasi ke Pembina, dan naikkan tingkatmu!",
                  style: TextStyle(
                    fontFamily: 'Urbanist', 
                    fontSize: 13, 
                    color: Colors.white.withValues(alpha: 0.9), 
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                
                // ==========================================
                // TOMBOL BARU: Tipis, Simpel, & Timbul
                // ==========================================
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100), // Bentuk pill/kapsul
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4), // Efek timbul (floating)
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: controller.goToUjiSku,
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8), // Padding tipis
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Mulai Uji SKU",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: AppTheme.secondary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppTheme.secondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // ==========================================
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Materi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary, fontFamily: "Poppins")),
        const SizedBox(height: 4),
        const Text("Kuasai kecakapan hidup yang esensial", style: TextStyle(color: AppTheme.onSurfaceVariant)),
        const SizedBox(height: 24),
        
        Column(
          children: List.generate(controller.materiList.length, (index) {
            final item = controller.materiList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => controller.openMateri(item["title"].toString()),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFD4C3BF)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(color: item["color"] as Color, borderRadius: BorderRadius.circular(18)),
                          child: Icon(item["icon"] as IconData, color: Colors.white),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item["title"].toString(),
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.secondary),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(item["description"].toString(), style: const TextStyle(height: 1.5, color: AppTheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        // 
      ],
    );
  }

  Widget _buildKarakterSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(36)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: AppTheme.secondaryContainer.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: 16, color: AppTheme.secondaryContainer),
                SizedBox(width: 6),
                Text("WAWASAN SCOUT", style: TextStyle(color: AppTheme.secondaryContainer, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("Pembentukan Karakter & Kepemimpinan", style: TextStyle(fontSize: 28, height: 1.3, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: "Poppins")),
          const SizedBox(height: 16),
          const Text(
            "Menjadi seorang Pramuka bukan hanya tentang keterampilan teknis, tetapi tentang membangun integritas dan kedisiplinan.",
            style: TextStyle(color: Colors.white70, height: 1.6),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildCharacterItem(Icons.verified_user_rounded, "Disiplin & Berani")),
              const SizedBox(width: 14),
              Expanded(child: _buildCharacterItem(Icons.diversity_3_rounded, "Rela Menolong")),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 220, width: double.infinity, color: AppTheme.secondary,
              child: Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuDiBmcSqXjNr0hK4QaK3lW-nRwDNh5jY5KVf03IUKGpGNf6MV3CWJPfUvTUlUlkpdegW2EiyiPoB5Sx-F_P51xgDEbLK5o_EA4tInv_IEDMqLvT4Ry1tFo6eH7Fu3BKHHDBHODHWUSicrnwO-c2NTBU2-lzCgdyW0xFhT5prhBZZbLdOT1bKDBvw6xzcVX-9133VnNJa7QNSK54xa3IpsbkfjpxSQs26DPgZXUqfGc5hVjNGhByGEIE0zllb0S9vXpecEmg8X8WYfw", fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.group_rounded, size: 80, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.secondaryContainer, size: 30),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ====================================================================
// WIDGET CUSTOM: BOUNCY 3D READ MORE BUTTON
// Tombol 3D interaktif khusus untuk seksi sejarah/artikel
// ====================================================================
class Bouncy3DReadMoreButton extends StatefulWidget {
  final VoidCallback onTap;

  const Bouncy3DReadMoreButton({
    super.key,
    required this.onTap,
  });

  @override
  State<Bouncy3DReadMoreButton> createState() => _Bouncy3DReadMoreButtonState();
}

class _Bouncy3DReadMoreButtonState extends State<Bouncy3DReadMoreButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        // Memberi sedikit jeda agar user melihat animasi tombol memantul naik
        Future.delayed(const Duration(milliseconds: 120), widget.onTap);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: double.infinity,
        height: 60, // Tinggi area total dengan shadow
        child: Stack(
          children: [
            // 1. Lapis Bawah (Shadow / Efek Ketebalan 3D)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 54,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.8), // Warna dasar digelapkan
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            
            // 2. Lapis Atas (Permukaan Tombol)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOutBack, // Animasi memantul
              left: 0,
              right: 0,
              top: _isPressed ? 6 : 0, // Turun 6 pixel saat ditekan
              height: 54,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15), // Efek highlight di tepi
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Baca Selengkapnya",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Widget Bantuan untuk Efek Transisi Animasi Tampil (Fade In + Slide)
class _AnimatedComponent extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedComponent({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        double startPoint = delay / (500 + delay);
        double animationProgress = value > startPoint ? (value - startPoint) / (1 - startPoint) : 0.0;
        return Opacity(
          opacity: animationProgress,
          child: Transform.translate(offset: Offset(0, 30 * (1 - animationProgress)), child: child),
        );
      },
      child: child,
    );
  }
}
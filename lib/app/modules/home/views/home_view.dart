import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/tabbar.dart';
import '../../theme/theme.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primary,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 120, 
                ),
                child: Column(
                  children: [
                    FadeInSlide(
                      delay: 0,
                      child: _buildHeader(),
                    ),
                    FadeInSlide(
                      delay: 150,
                      child: _buildHero(),
                    ),
                    FadeInSlide(
                      delay: 300,
                      child: _buildShortcuts(),
                    ),
                    const SizedBox(height: 32),
                    FadeInSlide(
                      delay: 450,
                      child: _buildAIFeature(),
                    ),
                    const SizedBox(height: 8),
                    FadeInSlide(
                      delay: 600,
                      child: _buildTopNews(), // Memanggil Berita Top
                    ),
                    // const SizedBox(height: 24),
                    // FadeInSlide(
                    //   delay: 750,
                    //   child: _buildActivities(), // Memanggil Log Aktivitas
                    // ),
                    
                  ],
                ),
              );
            }),
            
            Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              bottom: controller.isLoading.value ? -100 : 0, 
              left: 0,
              right: 0,
              child: const AppTabBar(currentIndex: 0),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFFFFDAD2), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    (controller.image.value).toString().trim().isNotEmpty
                        ? controller.image.value
                        : "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.account_circle, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        "Halo, Kak ${controller.usernameDisplay.value}!",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      )),
                  const SizedBox(height: 2),
                  const Text(
                    "Scoutify",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: controller.onNotificationTap,
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 240,
        margin: const EdgeInsets.only(bottom: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  "https://sipjkdlfjzmxptldxgxa.supabase.co/storage/v1/object/public/images/intro.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      Container(color: Colors.grey.shade300),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                        colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCA98),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        "HIGHLIGHT",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A532A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Jambore Nasional 2025",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Persiapkan dirimu untuk petualangan terbesar tahun ini.",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
      ),
    );
  }

  

Widget _buildShortcuts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tambahan Judul "Menu Cepat"
          
          const Text(
            "Menu Cepat",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 16), // Jarak antara judul dan grid
          
          GridView.builder(
            itemCount: controller.shortcuts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.65, // Disesuaikan sedikit agar animasi 3D + teks muat
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final item = controller.shortcuts[index];

              return Bouncy3DShortcut(
                icon: item["icon"] as IconData,
                title: item["title"].toString(),
                onTap: () => controller.onShortcutTap(item["id"].toString()),
              );
            },
          ),

        ],
      ),
    );
  }



  Widget _buildAIFeature() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDAD2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Color(0xFF2B1611)),
                  SizedBox(width: 6),
                  Text(
                    "TEKNOLOGI AI",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B1611),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        "https://sipjkdlfjzmxptldxgxa.supabase.co/storage/v1/object/public/images/kompress_squere.jpg",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "ANALYZING...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Deteksi Semaphore AI",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Identifikasi gerakan bendera semaphore secara real-time menggunakan kamera ponselmu dengan akurasi tinggi.",
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.6, color: AppTheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            
            // Menggunakan Bouncy3DButton yang baru dibuat
            Bouncy3DButton(
              title: "Mulai Deteksi",
              onTap: controller.onStartDetection,
            ),
            
            const SizedBox(height: 12), // Mengurangi padding bawah sedikit karena tombol 3D butuh ruang
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET BARU: BERITA TOP
  // ==========================================
  Widget _buildTopNews() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Berita Populer",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                  fontFamily: "Poppins",
                ),
              ),
              TextButton(
                onPressed: controller.onSeeAllNews,
                child: const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Obx(() {
            return Text(
              "Total: ${controller.totalTopNews.value}",
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.onSurfaceVariant.withValues(alpha: 0.75),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            );
          }),

          const SizedBox(height: 12),
          Obx(() {
            if (controller.topNews.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Belum ada berita.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: controller.topNews.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = controller.topNews[index];
                return _buildNewsCard(item);
              },
            );
          }),
        ],
      ),
    );
  }


  // ==========================================
  // AKTIVITAS (LOGS TERBARU)
  // ==========================================
  // Widget _buildActivities() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "Aktivitas Terkini",
  //           style: TextStyle(
  //             fontSize: 22,
  //             fontWeight: FontWeight.w600,
  //             color: AppTheme.primary,
  //             fontFamily: "Poppins",
  //           ),
  //         ),

  //         const SizedBox(height: 8),
  //         Obx(() {
  //           return Text(
  //             "Total: ${controller.totalRecentLogs.value}",
  //             style: TextStyle(
  //               fontSize: 12,
  //               color: AppTheme.onSurfaceVariant.withValues(alpha: 0.75),
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w600,
  //             ),
  //           );
  //         }),

  //         const SizedBox(height: 12),
  //         Obx(() {
  //           if (controller.recentLogs.isEmpty) {
  //             return const Center(
  //               child: Padding(
  //                 padding: EdgeInsets.all(20.0),
  //                 child: Text(
  //                   "Belum ada aktivitas tercatat.",
  //                   style: TextStyle(color: Colors.grey),
  //                 ),
  //               ),
  //             );
  //           }

  //           return ListView.separated(
  //             itemCount: controller.recentLogs.length,
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             separatorBuilder: (_, __) => const SizedBox(height: 10),
  //             itemBuilder: (context, index) {
  //               final item = controller.recentLogs[index];
  //               return _buildActivityCard(item);
  //             },
  //           );
  //         }),
  //       ],
  //     ),
  //   );
  // }

  // ==========================================
  // UI CARD: BERITA
  // ==========================================
  Widget _buildNewsCard(Map<String, String> item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => controller.onActivityTap(item),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  item["image"].toString(),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade100,
                    child: const Icon(
                      Icons.newspaper_rounded,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["category"].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF0BD8B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item["title"].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["time"].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // UI CARD: AKTIVITAS
  // ==========================================
  Widget _buildActivityCard(Map<String, String> item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => controller.onActivityTap(item),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  item["image"].toString(),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade100,
                    child: const Icon(
                      Icons.history_rounded,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["category"].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF0BD8B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item["title"].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 14, color: Color(0xFFB5A49E)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item["time"].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DashedDivider({
    super.key,
    this.height = 1.5, // Ketebalan garis
    this.color = Colors.grey, // Warna garis (bisa ganti ke AppTheme.primary)
    this.dashWidth = 6.0, // Panjang tiap strip
    this.dashSpace = 4.0, // Jarak antar strip
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Jarak atas-bawah
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
          
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: height,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10), // Bikin ujung strip agak membulat
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}


// ====================================================================
// WIDGET CUSTOM: FADE IN SLIDE ANIMATION
// ====================================================================
class FadeInSlide extends StatefulWidget {
  final Widget child;
  final int delay;
  final bool slideUp;

  const FadeInSlide({
    super.key,
    required this.child,
    required this.delay,
    this.slideUp = true,
  });

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(
      begin: widget.slideUp ? const Offset(0, 0.3) : const Offset(0, -0.3), 
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _timer = Timer(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

// ====================================================================
// WIDGET CUSTOM: BOUNCY 3D SHORTCUT BUTTON
// Memberikan efek timbul yang lucu dan interaktif saat ditekan
// ====================================================================
class Bouncy3DShortcut extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const Bouncy3DShortcut({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<Bouncy3DShortcut> createState() => _Bouncy3DShortcutState();
}

// ====================================================================
// WIDGET CUSTOM: BOUNCY 3D PRIMARY BUTTON
// Tombol panjang dengan efek 3D timbul untuk aksi utama
// ====================================================================
class Bouncy3DButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const Bouncy3DButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  State<Bouncy3DButton> createState() => _Bouncy3DButtonState();
}

class _Bouncy3DButtonState extends State<Bouncy3DButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        // Jeda untuk melihat animasi memantul sebelum berpindah layar
        Future.delayed(const Duration(milliseconds: 120), widget.onTap);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: double.infinity,
        height: 60, // Tinggi total area termasuk bayangan
        child: Stack(
          children: [
            // 1. Lapis Bawah (Shadow/Kedalaman 3D) - Warna lebih gelap dari primary
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 54, // Tinggi asli tombol
              child: Container(
                decoration: BoxDecoration(
                  // Menghasilkan warna bayangan dengan membuat warna primary sedikit transparan/gelap
                  color: AppTheme.primary.withValues(alpha: 0.7), 
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            
            // 2. Lapis Atas (Permukaan Tombol) - Bergerak saat ditekan
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOutBack,
              left: 0,
              right: 0,
              top: _isPressed ? 6 : 0, // Tombol turun 6 pixel saat ditekan
              height: 54,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2), // Sedikit highlight di pinggir
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bouncy3DShortcutState extends State<Bouncy3DShortcut> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        // Memberikan sedikit jeda agar user bisa melihat animasi tombol naik kembali
        Future.delayed(const Duration(milliseconds: 120), widget.onTap);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Area Stack untuk Tombol 3D
          SizedBox(
            width: 62,
            height: 68, // Tinggi ekstra untuk memberikan ruang kedalaman (depth)
            child: Stack(
              children: [
                // 1. Lapis Bawah (Shadow/Kedalaman 3D) - Posisi statis di bawah
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 62,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withValues(alpha: 0.25), // Warna bayangan
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                
                // 2. Lapis Atas (Permukaan Tombol) - Bergerak saat ditekan
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOutBack, // Efek memantul (bouncy) yang lucu
                  left: 0,
                  right: 0,
                  top: _isPressed ? 6 : 0, // Turun 6 pixel saat ditekan
                  height: 62,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppTheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.icon,
                        color: AppTheme.secondary,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // Teks Judul
          Expanded(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2, // Mencegah teks kepanjangan merusak layout
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

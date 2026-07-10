import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '..../../../../theme/theme.dart';
import '../controllers/info_logs_controller.dart';

class InfoLogsView extends GetView<InfoLogsController> {
  const InfoLogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu-abu sangat lembut
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // Mencegah perubahan warna saat di-scroll
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Jejak Petualanganku',
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.w800,
            fontFamily: "Poppins",
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          _buildFilterPopupMenu(),
        ],
      ),
      body: Column(
        children: [
          // Indikator Filter Aktif
          _buildActiveFilterIndicator(),

          // Area Konten dengan Animasi Transisi
          Expanded(
            child: Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _buildMainContent(),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==================== MAIN CONTENT STATE ====================
  Widget _buildMainContent() {
    if (controller.isLoading.value && controller.logs.isEmpty) {
      return Center(
        key: const ValueKey('loading'),
        child: CircularProgressIndicator(
          color: AppTheme.primary,
          strokeWidth: 3,
        ),
      );
    }

    if (controller.errorMessage.value.isNotEmpty && controller.logs.isEmpty) {
      return Container(
        key: const ValueKey('error'),
        child: _buildErrorState(),
      );
    }

    if (controller.logs.isEmpty) {
      return Container(
        key: const ValueKey('empty'),
        child: _buildEmptyState(),
      );
    }

    return RefreshIndicator(
      key: const ValueKey('list'),
      color: AppTheme.primary,
      backgroundColor: Colors.white,
      onRefresh: () async => await controller.refreshLogs(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: controller.logs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final log = controller.logs[index];
          // Animasi Staggered Entry untuk setiap baris
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 50).clamp(0, 400)),
            curve: Curves.easeOutQuint,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: _buildCoolLogCard(log),
          );
        },
      ),
    );
  }

  // ==================== FILTER INDICATOR ====================
  Widget _buildActiveFilterIndicator() {
    return Obx(() {
      final timeLabel = controller.timeFilter.value == '7hari' ? '7 Hari Terakhir' : 'Semua Waktu';
      final categoryLabel = controller.categoryFilter.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.filter_alt_rounded, size: 16, color: AppTheme.secondary),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  children: [
                    const TextSpan(text: "Menampilkan: "),
                    TextSpan(
                      text: "$timeLabel • $categoryLabel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==================== FILTER POPUP MENU ====================
  Widget _buildFilterPopupMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: AppTheme.primary),
      tooltip: "Filter Log",
      onSelected: (value) {
        if (value == '7hari' || value == 'semua') {
          controller.setTimeFilter(value);
        } else {
          controller.setCategoryFilter(value);
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          // --- HEADER WAKTU ---
          const PopupMenuItem<String>(
            enabled: false,
            height: 30,
            child: Text(
              "FILTER WAKTU",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
            ),
          ),
          PopupMenuItem<String>(
            value: '7hari',
            child: _buildPopupItem('7 Hari Terakhir', Icons.calendar_view_week_rounded, controller.timeFilter.value == '7hari'),
          ),
          PopupMenuItem<String>(
            value: 'semua',
            child: _buildPopupItem('Semua Waktu', Icons.history_rounded, controller.timeFilter.value == 'semua'),
          ),

          const PopupMenuDivider(),

          // --- HEADER KATEGORI ---
          const PopupMenuItem<String>(
            enabled: false,
            height: 30,
            child: Text(
              "FILTER KATEGORI",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
            ),
          ),
          ...controller.availableCategories.map((cat) {
            return PopupMenuItem<String>(
              value: cat,
              child: _buildPopupItem(
                cat,
                cat == 'Semua Kategori' ? Icons.category_rounded : Icons.label_outline_rounded,
                controller.categoryFilter.value == cat,
              ),
            );
          }),
        ];
      },
      elevation: 6,
      color: Colors.white,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
    );
  }

  // Helper untuk item menu dengan ikon ceklis
  Widget _buildPopupItem(String title, IconData icon, bool isSelected) {
    return Row(
      children: [
        Icon(icon, color: isSelected ? AppTheme.primary : Colors.grey[500], size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppTheme.primary : const Color(0xFF374151),
              fontFamily: "Poppins",
            ),
          ),
        ),
        if (isSelected)
          Icon(Icons.check_circle_rounded, color: AppTheme.secondary, size: 16),
      ],
    );
  }

  // ==================== LOG CARD ====================
  Widget _buildCoolLogCard(dynamic log) {
    String formattedDate = "-";
    String timeOnly = "-";

    if (log['created_at'] != null) {
      try {
        final DateTime dt = DateTime.parse(log['created_at']).toLocal();
        final day = dt.day.toString().padLeft(2, '0');
        final month = dt.month.toString().padLeft(2, '0');
        final hour = dt.hour.toString().padLeft(2, '0');
        final minute = dt.minute.toString().padLeft(2, '0');

        formattedDate = "$day/$month/${dt.year}";
        timeOnly = "$hour:$minute WIB";
      } catch (e) {
        formattedDate = "Format tidak dikenali";
      }
    }

    String activityText = log['activity'] ?? 'Aktivitas Tidak Diketahui';

    // Palet warna yang lembut dan profesional
    List<Color> cuteColors = [
      const Color(0xFFE3F2FD), // Light Blue
      const Color(0xFFF3E5F5), // Light Purple
      const Color(0xFFE8F5E9), // Light Green
      const Color(0xFFFFF3E0), // Light Orange
    ];
    
    // Warna teks aksen yang lebih gelap untuk kontras
    List<Color> darkColors = [
      const Color(0xFF1565C0),
      const Color(0xFF6A1B9A),
      const Color(0xFF2E7D32),
      const Color(0xFFEF6C00),
    ];

    int colorIndex = activityText.length % cuteColors.length;
    Color iconBgColor = cuteColors[colorIndex];
    Color iconTextColor = darkColors[colorIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon Beraksen
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              activityText.isNotEmpty ? activityText[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: iconTextColor,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Konten Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Baris Badge Info (Tanggal & Waktu)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildMiniBadge(Icons.calendar_today_rounded, formattedDate),
                    _buildMiniBadge(Icons.access_time_rounded, timeOnly),
                  ],
                ),

                // Baris IP Address jika ada
                if (log['ip_address'] != null && log['ip_address'] != 'unknown') ...[
                  const SizedBox(height: 8),
                  _buildMiniBadge(Icons.router_rounded, log['ip_address'], isOutline: true),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(IconData icon, String text, {bool isOutline = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: isOutline ? Border.all(color: const Color(0xFFE5E7EB)) : Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6B7280)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY & ERROR STATES ====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 56,
              color: AppTheme.primary.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Jejak Tidak Ditemukan",
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Coba ubah kombinasi filter waktu\ndan kategori di pojok kanan atas.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              fontFamily: "Poppins",
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: Colors.red.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(
                color: Color(0xFF4B5563), 
                fontFamily: "Poppins", 
                fontSize: 13
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.fetchLogs,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.sync_rounded, size: 18),
            label: const Text(
              "Muat Ulang", 
              style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: 13)
            ),
          )
        ],
      ),
    );
  }
}
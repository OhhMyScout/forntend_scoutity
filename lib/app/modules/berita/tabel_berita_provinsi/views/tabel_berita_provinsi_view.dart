import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../controllers/tabel_berita_provinsi_controller.dart';

class TabelBeritaProvinsiView extends GetView<TabelBeritaProvinsiController> {
  const TabelBeritaProvinsiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Latar belakang abu-abu terang khas dashboard
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        centerTitle: true,
        title: const Text(
          "Data Sebaran Provinsi",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF3B82F6)),
            tooltip: 'Muat Ulang',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Obx(
        () {
          // 1. STATE: Loading
          if (controller.isLoading.value && controller.provinsiList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            );
          }

          // 2. STATE: Error
          if (controller.errorMessage.isNotEmpty && controller.provinsiList.isEmpty) {
            return _buildErrorState();
          }

          // 3. STATE: Sukses / Data Tersedia
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: const Color(0xFF3B82F6),
            child: Column(
              children: [
                _buildKPICards(),
                _buildSearch(),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTableHeader(),
                        Expanded(
                          child: Obx(
                            () {
                              final data = controller.filteredProvinsi;

                              if (data.isEmpty) {
                                return _buildEmptyState();
                              }

                              // Mencari nilai maksimum untuk kalkulasi visualisasi Bar Chart
                              final double maxBerita = data.fold<double>(
                                1.0,
                                (maxVal, item) {
                                  final val = (item["jumlah_berita"] ?? 0).toDouble();
                                  return val > maxVal ? val : maxVal;
                                },
                              );

                              return ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                itemCount: data.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade100,
                                ),
                                itemBuilder: (context, index) {
                                  return _buildDataRow(
                                    index: index,
                                    item: data[index],
                                    maxVal: maxBerita,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // KOMPONEN UI DATA & VISUALISASI
  // =========================================================

  Widget _buildKPICards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: _kpiCard(
              title: "Total Provinsi",
              value: controller.jumlahProvinsi.toString(),
              icon: Icons.map_outlined,
              color: const Color(0xFF3B82F6), // Blue
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _kpiCard(
              title: "Total Berita",
              value: controller.totalBerita.toString(),
              icon: Icons.article_outlined,
              color: const Color(0xFF10B981), // Emerald
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 46,
        child: TextField(
          onChanged: controller.updateSearch,
          decoration: InputDecoration(
            hintText: "Saring data provinsi...",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              "#",
              style: _headerTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text("PROVINSI", style: _headerTextStyle()),
          ),
          Expanded(
            flex: 4,
            child: Text("VISUALISASI DATA", style: _headerTextStyle()),
          ),
          SizedBox(
            width: 50,
            child: Text(
              "TOTAL",
              style: _headerTextStyle(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerTextStyle() {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade600,
      letterSpacing: 0.5,
    );
  }

  Widget _buildDataRow({required int index, required Map<String, dynamic> item, required double maxVal}) {
    final int jumlah = item["jumlah_berita"] ?? 0;
    
    // Kalkulasi lebar bar chart (persentase dari nilai maksimum)
    final double persentase = maxVal > 0 ? (jumlah / maxVal) : 0.0;
    
    // Pewarnaan dinamis: Top 3 mendapat warna khusus
    Color barColor;
    if (index == 0) barColor = const Color(0xFF3B82F6); // Peringkat 1
    else if (index == 1) barColor = const Color(0xFF60A5FA); // Peringkat 2
    else if (index == 2) barColor = const Color(0xFF93C5FD); // Peringkat 3
    else barColor = const Color(0xFFCBD5E1); // Sisanya

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kolom 1: Peringkat
          SizedBox(
            width: 30,
            child: Text(
              "${index + 1}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: index < 3 ? FontWeight.bold : FontWeight.w500,
                color: index < 3 ? const Color(0xFF1E293B) : Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Kolom 2: Nama Provinsi
          Expanded(
            flex: 3,
            child: Text(
              item["provinsi"] ?? "-",
              style: TextStyle(
                fontSize: 13,
                fontWeight: index < 3 ? FontWeight.w600 : FontWeight.w500,
                color: const Color(0xFF334155),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Kolom 3: Visualisasi Data (Bar Chart Horizontal)
          Expanded(
            flex: 4,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Container(
                      height: 18,
                      width: max(constraints.maxWidth * persentase, 4.0), // Minimal width 4px agar tetap terlihat jika 0
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Kolom 4: Total Angka
          SizedBox(
            width: 50,
            child: Text(
              "$jumlah",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: index < 3 ? const Color(0xFF1E293B) : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF475569)),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: controller.getDataProvinsi,
            icon: const Icon(Icons.refresh),
            label: const Text("Muat Ulang Data"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.table_chart_outlined, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            "Tidak ada data yang cocok",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
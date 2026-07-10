import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sejarah_pramuka_controller.dart';

class SejarahPramukaView extends GetView<SejarahPramukaController> {
  const SejarahPramukaView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4E342E); 
    const secondaryColor = Color(0xFF8D6E63);
    const backgroundColor = Color(0xFFFCF9F4); 

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// =========================================
          /// 1. SLIVER APP BAR (HEADER)
          /// =========================================
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16, right: 20),
              title: const Text(
                'Ensiklopedia\nPramuka',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  height: 1.2,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF5D4037), Color(0xFF3E2723)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 160,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// =========================================
          /// 2. GALERI FOTO SEJARAH (DINAMIS DARI FOLDER)
          /// =========================================
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoadingGaleri.value) {
                // Tampilan loading selama mencari foto
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }

              if (controller.daftarGaleri.isEmpty) {
                // Tampilan peringatan jika folder kosong / pubspec belum di-setup
                return Container(
                  height: 100,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "Galeri kosong.\nPastikan assets/images/sejarah sudah didaftarkan di pubspec.yaml",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                );
              }

              // Jika data ada, render carousel galeri
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      "Galeri Sejarah",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.daftarGaleri.length,
                      itemBuilder: (context, index) {
                        return _buildGaleriItem(controller.daftarGaleri[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.grey[300], thickness: 1.5),
                  ),
                ],
              );
            }),
          ),

          /// =========================================
          /// 3. DAFTAR MATERI (TEXT & ANIMASI KARTU)
          /// =========================================
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildInteractiveTextCard(
                    controller.daftarMateri[index],
                    primaryColor,
                    secondaryColor,
                  );
                },
                childCount: controller.daftarMateri.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// WIDGET: Item Galeri (Foto Polaroid Style)
  Widget _buildGaleriItem(GaleriSejarah foto) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: InkWell(
                onTap: () {
                  Get.dialog(
                    Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(20),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color: Colors.black,
                              constraints: const BoxConstraints(maxHeight: 520),
                              child: Image.asset(
                                foto.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.black,
                                    padding: const EdgeInsets.all(24),
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported_rounded,
                                        color: Colors.white,
                                        size: 44,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.close_rounded),
                              color: Colors.white,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.55),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    barrierDismissible: true,
                  );
                },
                child: Image.asset(
                  foto.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback icon jika gambar rusak agar tidak crash
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
               foto.caption,
               maxLines: 2,
               overflow: TextOverflow.ellipsis,
               style: const TextStyle(
                 fontSize: 12,
                 fontWeight: FontWeight.w600,
                 color: Colors.black87,
                 height: 1.3,
               ),
               textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// WIDGET: Kartu Materi Interaktif (Hanya Tulisan & Animasi)
  Widget _buildInteractiveTextCard(ArtikelPramuka artikel, Color primaryColor, Color secondaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Obx(() {
        final isExpanded = controller.expandedArtikelId.value == artikel.id;

        return GestureDetector(
          onTap: () => controller.toggleArtikel(artikel.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: isExpanded ? Colors.white : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (isExpanded)
                  BoxShadow(
                    color: primaryColor.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                else
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
              ],
              border: Border.all(
                color: isExpanded ? primaryColor.withOpacity(0.6) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isExpanded ? primaryColor : primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          artikel.icon,
                          color: isExpanded ? Colors.white : primaryColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artikel.kategori.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              artikel.judul,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey[500],
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  child: ConstrainedBox(
                    constraints: isExpanded
                        ? const BoxConstraints()
                        : const BoxConstraints(maxHeight: 0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(color: Colors.grey[200], thickness: 1.5),
                          const SizedBox(height: 12),
                          Text(
                            artikel.konten,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
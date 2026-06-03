// lib/app/modules/edukasi/beranda_edukasi/views/beranda_edukasi_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../../../theme/tabbar.dart';
import '../controllers/beranda_edukasi_controller.dart';

class BerandaEdukasiView
    extends GetView<BerandaEdukasiController> {
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
                left: 20,
                right: 20,
                top: 20,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildAppBar(),

                  const SizedBox(height: 24),

                  _buildHeroBanner(),

                  const SizedBox(height: 32),

                  _buildSejarahSection(),

                  const SizedBox(height: 36),

                  _buildMateriSection(),

                  const SizedBox(height: 36),

                  _buildKarakterSection(),
                ],
              ),
            ),

            Align(
              alignment:
                  Alignment.bottomCenter,
              child: AppTabBar(
                currentIndex: 1,
              ),
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
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Edukasi",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontFamily: "Poppins",
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.school,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color(0xFF4E342E),
        borderRadius:
            BorderRadius.circular(28),
      ),

      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.school,
              size: 130,
              color:
                  Colors.white.withValues(
                alpha: 0.08,
              ),
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: const [
              Text(
                "Pusat Belajar Pramuka",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.white,
                  fontFamily:
                      "Poppins",
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Tingkatkan wawasan dan keterampilan kepramukaanmu.",
                style: TextStyle(
                  color:
                      Color(0xFFE5BEB5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSejarahSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(24),
          child: Stack(
            children: [
              Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuDUffgz211IFK-iJYK2VdgnfLt-UGalP_YDtOIYFo42SH1oGuhJt1GwnBiYvsE8ZxhGqz11j40QJ-vqCA_eyGbVCb3cCncvpVeztSNNDainfl94kbwjYUbLgbhx05tD0RQViRP1CGUGDC9OGA-BDc_Ii9VsvELGRzeLQqJGfcDuPn_YILEbpbDHcq-hn92aV9IouXiuEbF2f556ewEnjJxurI3Ru7xpAt1K0Fcv4o5UOGTqxneUDktjx6OXxNZnWxO9pSRttMqdO6g",
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Positioned.fill(
                child: Container(
                  decoration:
                      const BoxDecoration(
                    gradient:
                        LinearGradient(
                      begin:
                          Alignment
                              .bottomCenter,
                      end:
                          Alignment
                              .topCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
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
            fontWeight:
                FontWeight.bold,
            color: AppTheme.primary,
            fontFamily: "Poppins",
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          "Berawal dari gagasan Lord Baden-Powell di Inggris, gerakan Kepramukaan telah menyebar ke seluruh penjuru dunia termasuk Indonesia.",
          style: TextStyle(
            height: 1.7,
            color:
                AppTheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  AppTheme.primary,
              foregroundColor:
                  Colors.white,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
            ),
            onPressed:
                controller.openSejarah,
            child: const Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  "Baca Selengkapnya",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(width: 8),

                Icon(
                  Icons.arrow_forward,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMateriSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          "Materi",
          style: TextStyle(
            fontSize: 24,
            fontWeight:
                FontWeight.bold,
            color: AppTheme.primary,
            fontFamily: "Poppins",
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          "Kuasai kecakapan hidup yang esensial",
          style: TextStyle(
            color:
                AppTheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 24),

        Column(
          children: List.generate(
            controller.materiList.length,
            (index) {
              final item =
                  controller.materiList[index];

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 16,
                ),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                  onTap: () =>
                      controller.openMateri(
                    item["title"]
                        .toString(),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius
                              .circular(
                        24,
                      ),
                      border: Border.all(
                        color: const Color(
                          0xFFD4C3BF,
                        ),
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration:
                              BoxDecoration(
                            color: item[
                                    "color"]
                                as Color,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                          ),
                          child: Icon(
                            item["icon"]
                                as IconData,
                            color:
                                Colors.white,
                          ),
                        ),

                        const SizedBox(
                            width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Text(
                                    item["title"]
                                        .toString(),
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          20,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      color:
                                          AppTheme.primary,
                                    ),
                                  ),

                                  const Icon(
                                    Icons
                                        .arrow_forward_ios,
                                    size:
                                        18,
                                    color:
                                        AppTheme.secondary,
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height:
                                      8),

                              Text(
                                item[
                                        "description"]
                                    .toString(),
                                style:
                                    const TextStyle(
                                  height:
                                      1.5,
                                  color:
                                      AppTheme.onSurfaceVariant,
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
            },
          ),
        ),

        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                0xFF4E342E,
              ),
              foregroundColor:
                  Colors.white,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
            ),
            onPressed:
                controller.lihatSemua,
            child: const Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  "Lihat Semua",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(width: 8),

                Icon(
                  Icons.open_in_new,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKarakterSection() {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius:
            BorderRadius.circular(36),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color:
                  const Color(0x33FFCA98),
              borderRadius:
                  BorderRadius.circular(
                100,
              ),
            ),
            child: const Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color:
                      Color(0xFFFFCA98),
                ),

                SizedBox(width: 6),

                Text(
                  "WAWASAN SCOUT",
                  style: TextStyle(
                    color:
                        Color(0xFFFFCA98),
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Pembentukan Karakter & Kepemimpinan",
            style: TextStyle(
              fontSize: 30,
              height: 1.2,
              fontWeight:
                  FontWeight.bold,
              color: Colors.white,
              fontFamily: "Poppins",
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            "Menjadi seorang Pramuka bukan hanya tentang keterampilan teknis, tetapi tentang membangun integritas dan kedisiplinan.",
            style: TextStyle(
              color:
                  Colors.white70,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child:
                    _buildCharacterItem(
                  Icons.verified_user,
                  "Disiplin & Berani",
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child:
                    _buildCharacterItem(
                  Icons.diversity_3,
                  "Rela Menolong",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              24,
            ),
            child: Image.network(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuDiBmcSqXjNr0hK4QaK3lW-nRwDNh5jY5KVf03IUKGpGNf6MV3CWJPfUvTUlUlkpdegW2EiyiPoB5Sx-F_P51xgDEbLK5o_EA4tInv_IEDMqLvT4Ry1tFo6eH7Fu3BKHHDBHODHWUSicrnwO-c2NTBU2-lzCgdyW0xFhT5prhBZZbLdOT1bKDBvw6xzcVX-9133VnNJa7QNSK54xa3IpsbkfjpxSQs26DPgZXUqfGc5hVjNGhByGEIE0zllb0S9vXpecEmg8X8WYfw",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterItem(
    IconData icon,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.05,
        ),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(
              0xFFFFCA98,
            ),
            size: 30,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
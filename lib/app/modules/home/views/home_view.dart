// lib/app/modules/home/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/tabbar.dart';
import '../../theme/theme.dart';
import '../controllers/home_controller.dart';

  class HomeView
    extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 120,
              ),
              child: Column(
                children: [
                  _buildHeader(),

                  _buildHero(),

                  _buildShortcuts(),

                  _buildAIFeature(),

                  _buildActivities(),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: AppTabBar(
                currentIndex: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(
                      0xFFFFDAD2,
                    ),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(100),
                  child: Image.network(
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuCO6SwgDcXiSEZt2p81N3EGNfZ411awRII5qqZIjZYt64IC51nQAZEOFz4F88OAEg8420a4bnKCtxL9WMeGqEhEOUef9Q_Bbos3howCFOKGNuGV3wqWYEsxbxkcWteztEgfhOOU3HkH5bw9VQja75kQLGTImNtPoKoHycgopkJ606Yb7lkiWIQK3VvzqImjlFyI1DWKE8LE-rsSCXR5zKCG3X3R_S5fkfBR-YXQ3l-Rjm29-M43_hzxn7YTOZjGK6dyEoAIO-Ns8N4",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo, Kak Adit!",
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          AppTheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    "Scoutify",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w600,
                      color: AppTheme.primary,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ],
          ),

          IconButton(
            onPressed:
                controller.onNotificationTap,
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
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        height: 240,
        margin: const EdgeInsets.only(
          bottom: 32,
        ),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuCmvnNGiNaQb30r5rKcTEAzNDbTAM2bqXg1xtX-HX_iYdvqZjvFww6Z7MgHdC1axe0ALqcHJ6sFMTStTUlPEesq4Lxwakk-mxaAhE2p1VDmlL_Haq1fGE1U74fuCXD_WYhQNoW8S5L843iCfW5hU2478F1UpH-t284YXbn9ZQSjNBIPMse86j2ZWc-uGUk2SFL0zedSFNOwiQUUnxPrfthkWVfJ222pIP8PbAK7D7L9VSyqBkzv6zDJV7qCawt_TvqqVH1dE_iwQDo",
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin:
                          Alignment.topCenter,
                      end:
                          Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(
                          alpha: 0.7,
                        ),
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFFFCA98,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: const Text(
                        "HIGHLIGHT",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                          color: Color(
                            0xFF7A532A,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Jambore Nasional 2024",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Persiapkan dirimu untuk petualangan terbesar tahun ini.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
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

  Widget _buildShortcuts() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: GridView.builder(
        itemCount:
            controller.shortcuts.length,
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.72,
          crossAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final item =
              controller.shortcuts[index];

          return GestureDetector(
            onTap: () => controller
                .onShortcutTap(
              item["title"].toString(),
            ),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.06,
                        ),
                        blurRadius: 18,
                        offset: const Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    color:
                        AppTheme.secondary,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  item["title"].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAIFeature() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFFFDAD2,
                ),
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
                    Icons.auto_awesome,
                    size: 16,
                    color: Color(
                      0xFF2B1611,
                    ),
                  ),

                  SizedBox(width: 6),

                  Text(
                    "TEKNOLOGI AI",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.bold,
                      color: Color(
                        0xFF2B1611,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Deteksi Semaphore AI",
              style: TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.w600,
                color: AppTheme.primary,
                fontFamily: "Poppins",
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Identifikasi gerakan bendera semaphore secara real-time menggunakan kamera ponselmu dengan akurasi tinggi.",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.6,
                color:
                    AppTheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme.primary,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      100,
                    ),
                  ),
                ),
                onPressed:
                    controller.onStartDetection,
                child: const Text(
                  "Mulai Deteksi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuDUIH3Kz3lCqoaGvQ7lTdtU0iaVNpP1H2JzSL6ZmecE8cFHO6m4RIK-Lw7AT86L-DQVeG0swfi6SjOcmoUMNU4RzLdZcJg1eOX1fL1B0lMtt6yQ4qXEc6TKFh2-wkNX3t3B039rXh4TUYEvbXc7piTzdK37sjvGS__4Xs1_owQ41ggogixv-Pm_SlqhTxuDIQ9ISqOHwjrfBA0_4gHlgNnnJmwqkRJN4ShA7WWpiPm2He3b5JWH0z4Fu61T-UnfjiVvdLi5oD3USH8",
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black
                              .withValues(
                            alpha: 0.4,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: const Text(
                          "ANALYZING...",
                          style: TextStyle(
                            color:
                                Colors.white,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: Container(
                        margin:
                            const EdgeInsets.all(
                          18,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white
                                .withValues(
                              alpha: 0.4,
                            ),
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
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

  Widget _buildActivities() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Aktivitas Terkini",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w600,
                  color: AppTheme.primary,
                  fontFamily: "Poppins",
                ),
              ),

              TextButton(
                onPressed:
                    controller.onSeeAll,
                child: const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color:
                        AppTheme.secondary,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ListView.builder(
            itemCount:
                controller.activities.length,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item =
                  controller.activities[index];

              return Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 16,
                ),
                padding:
                    const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.04,
                      ),
                      blurRadius: 14,
                      offset: const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      child: Image.network(
                        item["image"]
                            .toString(),
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            item["category"]
                                .toString(),
                            style:
                                const TextStyle(
                              fontSize: 10,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color: Color(
                                0xFFF0BD8B,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            item["title"]
                                .toString(),
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w600,
                              color: AppTheme
                                  . onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            item["time"]
                                .toString(),
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: AppTheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
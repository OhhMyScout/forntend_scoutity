import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {

  const FeedbackView({super.key});

  static const Color primaryColor =
      Color(0xFF361F1A);

  static const Color secondaryColor =
      Color(0xFF7D562D);

  static const Color backgroundColor =
      Color(0xFFFCF9F4);

  static const Color textSecondary =
      Color(0xFF504442);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Get.back(),

          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),

        title: const Text(
          'Umpan Balik',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// HERO CHIP
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: const Color(0xFFFFCA98),
                borderRadius:
                    BorderRadius.circular(100),
              ),

              child: const Row(
                mainAxisSize: MainAxisSize.min,

                children: [

                  Icon(
                    Icons.edit_note,
                    size: 20,
                    color: Color(0xFF7A532A),
                  ),

                  SizedBox(width: 8),

                  Text(
                    'Suara Pengguna',
                    style: TextStyle(
                      color: Color(0xFF7A532A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Bantu Kami Berkembang',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'Pengalaman petualangan Anda adalah prioritas kami. Ceritakan masukan, saran, atau kendala yang Anda temui selama menggunakan Scoutify.',
              style: TextStyle(
                color: textSecondary,
                height: 1.7,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            /// QUOTE CARD
            buildCard(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Icon(
                    Icons.format_quote,
                    size: 50,
                    color: secondaryColor,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    '"Setiap saran kecil adalah langkah besar untuk komunitas pramuka digital."',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(18),

                    child: Image.network(
                      'https://sipjkdlfjzmxptldxgxa.supabase.co/storage/v1/object/public/images/intro.png',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// CATEGORY
            buildCard(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Pilih Kategori',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,

                    children: [

                      buildCategory(
                        icon: Icons.bug_report,
                        label: 'Bug & Error',
                        value: 'bug',
                      ),

                      buildCategory(
                        icon: Icons.lightbulb,
                        label: 'Saran Fitur',
                        value: 'suggestion',
                      ),

                      buildCategory(
                        icon: Icons.more_horiz,
                        label: 'Lainnya',
                        value: 'other',
                      ),

                      buildCategory(
                        icon: Icons.help,
                        label: 'Pertanyaan',
                        value: 'question',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// MESSAGE
            buildCard(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Pesan Anda',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                        controller.messageController,

                    maxLines: 6,

                    decoration: InputDecoration(
                      hintText:
                          'Tuliskan detail masukan Anda di sini...',
                      filled: true,
                      fillColor:
                          const Color(0xFFF6F3EE),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),

                        borderSide:
                            const BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// RATING
            buildCard(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    'Nilai',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Obx(
                    () => Row(
                      children: List.generate(
                        5,
                        (index) {

                          final active =
                              index <
                              controller.rating.value;

                          return IconButton(
                            onPressed: () {
                              controller.setRating(
                                index + 1,
                              );
                            },

                            icon: Icon(
                              Icons.star,
                              color: active
                                  ? secondaryColor
                                  : Colors.grey.shade300,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed:
                    controller.submitFeedback,

                icon: const Icon(Icons.send),

                label: const Text(
                  'Kirim Masukan',
                ),

                style:
                    ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                      primaryColor,
                  foregroundColor:
                      Colors.white,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      100,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Center(
              child: Text(
                'Kami menghargai privasi Anda. Umpan balik dikirim secara anonim.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 30),

            buildInfoCard(
              backgroundColor:
                  const Color(0xFFFFDBCF),

              iconBackground:
                  const Color(0xFF513329),

              icon: Icons.mail,

              title: 'Butuh Bantuan Cepat?',

              subtitle:
                  'Jika mengalami kendala mendesak, hubungi support kami di scoutify.trycenter.my.id',
            ),

            const SizedBox(height: 18),

            buildInfoCard(
              backgroundColor:
                  const Color(0xFFFFDCBD),

              iconBackground:
                  secondaryColor,

              icon: Icons.forum,

              title: 'Komunitas',

              subtitle:
                  'Diskusikan ide bersama anggota pramuka di Forum Scoutify.',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(
              alpha: 0.05,
            ),

            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: child,
    );
  }

  Widget buildCategory({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Obx(() {

      final selected =
          controller.selectedCategory.value ==
              value;

      return GestureDetector(
        onTap: () {
          controller.selectCategory(value);
        },

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),

          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFF0BD8B)
                : const Color(0xFFF6F3EE),

            borderRadius:
                BorderRadius.circular(18),

            border: Border.all(
              color: selected
                  ? secondaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(
                icon,
                size: 18,
                color: selected
                    ? primaryColor
                    : textSecondary,
              ),

              const SizedBox(width: 8),

              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? primaryColor
                      : textSecondary,

                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildInfoCard({
    required Color backgroundColor,
    required Color iconBackground,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius:
                  BorderRadius.circular(16),
            ),

            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// views/tali_temali_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tali_temali_controller.dart';

class TaliTemaliView extends GetView<TaliTemaliController> {
  const TaliTemaliView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF9F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFCF9F4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff361F1A)),
          onPressed: () {},
        ),
        title: const Text(
          "Scoutify",
          style: TextStyle(
            color: Color(0xff361F1A),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Text(
                  "Home",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(width: 20),
                Text(
                  "Library",
                  style: TextStyle(
                    color: Color(0xff361F1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  "Games",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tali Temali",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xff361F1A),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Kumpulan simpul dan ikatan dasar hingga mahir dalam pramuka. Pelajari seni mengikat yang kokoh dan estetis untuk kebutuhan petualanganmu.",
              style: TextStyle(
                fontSize: 18,
                height: 1.7,
                color: Color(0xff504442),
              ),
            ),
            const SizedBox(height: 40),

            Obx(
              () => GridView.builder(
                itemCount: controller.items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final item = controller.items[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: Image.network(
                            item.image,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style:
                                          const TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(
                                            0xff361F1A),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: item.level ==
                                              "Dasar"
                                          ? const Color(
                                              0xffF0EDE9)
                                          : const Color(
                                              0xffFFCA98),
                                      borderRadius:
                                          BorderRadius
                                              .circular(30),
                                    ),
                                    child: Text(
                                      item.level,
                                      style:
                                          const TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color:
                                      Color(0xff504442),
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
            ),

            const SizedBox(height: 50),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xff361F1A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tips Merawat Tali",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Pastikan perlengkapan scouting-mu selalu dalam kondisi prima. Tali yang terawat adalah kunci keamanan di alam bebas.",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xffFFCA98),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Simpan di tempat yang kering dan teduh",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xffFFCA98),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Bersihkan dari kotoran atau lumpur",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 30),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          const Color(0xff361F1A),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text(
                      "Pelajari Lebih Lanjut",
                    ),
                  ),
                ],
              ),
            ),
  
            const SizedBox(height: 50),

            const Center(
              child: Text(
                "Scoutify © 2024 • Refined Wilderness Design System",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
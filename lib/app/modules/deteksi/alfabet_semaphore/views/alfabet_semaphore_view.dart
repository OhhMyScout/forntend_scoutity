import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/alfabet_semaphore_controller.dart';

class AlfabetSemaphoreView
    extends GetView<AlfabetSemaphoreController> {
  const AlfabetSemaphoreView({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xffFCF9F4);
    const primaryColor = Color(0xff361F1A);
    const secondaryColor = Color(0xff7D562D);
    const secondaryContainer = Color(0xffFFCA98);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        title: const Text(
          'Alfabet Semaphore',
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

            const Center(
              child: Column(
                children: [
                  Text(
                    'Panduan Isyarat Bendera',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Semaphore adalah metode komunikasi visual menggunakan sepasang bendera.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Row(
              children: const [
                Icon(
                  Icons.sort_by_alpha,
                  color: secondaryColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Huruf Alfabet (A-Z)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Obx(
              () => GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount:
                    controller.semaphoreList.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final item =
                      controller.semaphoreList[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [

                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                            child: Image.network(
                              item['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          item['letter']!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),

                        Text(
                          item['code']!,
                          style: const TextStyle(
                            color: secondaryColor,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Row(
                    children: const [
                      Icon(
                        Icons.pin,
                        color: secondaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Angka Semaphore',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding:
                        const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xffF6F3EE,
                      ),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Untuk mengirim angka, gunakan tanda angka terlebih dahulu.',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: const [

                  Icon(
                    Icons.lightbulb,
                    color: secondaryContainer,
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Tips Belajar Cepat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Bayangkan sebuah jam raksasa di depanmu untuk menghafal posisi tangan semaphore.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
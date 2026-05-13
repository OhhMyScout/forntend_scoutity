import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {

    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);
    const backgroundColor = Color(0xFFFAF7F2);
    const surfaceColor = Colors.white;
    const textSecondary = Color(0xFF504442);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),

        title: const Text(
          'Kebijakan & Privasi',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              children: const [

                Icon(
                  Icons.security,
                  color: secondaryColor,
                  size: 18,
                ),

                SizedBox(width: 8),

                Text(
                  'INFORMASI LEGAL',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              'Kebijakan Privasi Scoutify',
              style: TextStyle(
                color: primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Terakhir diperbarui: 24 Mei 2024',
              style: TextStyle(
                color: textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 24),

            /// INTRODUCTION
            buildSection(
              icon: Icons.info,
              title: '1. Pendahuluan',
              content:
                  'Selamat datang di Scoutify. Kami sangat menghargai kepercayaan Anda dan berkomitmen untuk melindungi data pribadi Anda. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan menjaga informasi Anda saat Anda menggunakan aplikasi pramuka digital kami.',
            ),

            const SizedBox(height: 20),

            /// DATA COLLECTION
            buildCollectionSection(),

            const SizedBox(height: 20),

            /// IMAGE
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAtKbWq7M06bfGf9-dSNW-xbE_TyAiV4KNE0LUNZcBIbDnSAN9GSPpXSIA1-tHwANDaW5N8AByJZdjWC-pqJwvP0ZoduJCKeDRnA38LPjeJFJvl2qThJMv1oX-CGZ-KsHgBMbmkn43ej8Wbr-qguMUZirgulABGRsMaqPh8X0SN_LNNaDueVpTKHiiKWpCWE0zz85DzYfXca8KNBtJR6_Ec5IqsD-vlPvo3NPjGGVvO4UeHXhVvv7MAVG095srPRuCaVdQcy5V-Zto',
                  ),
                  fit: BoxFit.cover,
                ),
              ),

              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),

                child: const Text(
                  '"Keamanan Anda adalah prioritas utama kami dalam setiap langkah petualangan."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DATA USAGE
            buildUsageSection(),

            const SizedBox(height: 20),

            /// SECURITY
            buildSection(
              icon: Icons.verified_user,
              title: '4. Keamanan Data',
              content:
                  'Kami menggunakan enkripsi tingkat industri untuk melindungi data sensitif Anda. Scoutify tidak akan pernah menjual informasi pribadi Anda kepada pihak ketiga untuk tujuan pemasaran tanpa izin eksplisit dari Anda.',
            ),

            const SizedBox(height: 30),

            /// CONTACT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                color: const Color(0xFF4E342E),
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                children: [

                  const Text(
                    'Punya Pertanyaan?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Jika Anda memiliki pertanyaan tentang kebijakan privasi kami atau bagaimana kami menangani data Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFC19C94),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: controller.contactSupport,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),

                    child: const Text(
                      'Hubungi Dukungan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// FOOTER
            const Center(
              child: Text(
                '© 2024 Scoutify Indonesia. Semua Hak Dilindungi Undang-Undang.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                TextButton(
                  onPressed: controller.openTerms,
                  child: const Text(
                    'Syarat & Ketentuan',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: controller.openHelpCenter,
                  child: const Text(
                    'Pusat Bantuan',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: const Color(0xFFFFCA98),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: const Color(0xFF7A532A),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF361F1A),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF504442),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCollectionSection() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFCA98),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.storage,
                  color: Color(0xFF7A532A),
                ),
              ),

              const SizedBox(width: 16),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      '2. Pengumpulan Data',
                      style: TextStyle(
                        color: Color(0xFF361F1A),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Kami mengumpulkan beberapa jenis informasi untuk memberikan layanan terbaik kepada Anda.',
                      style: TextStyle(
                        color: Color(0xFF504442),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          buildBullet(
            'Informasi Akun',
            'Nama, email, dan tanggal lahir untuk verifikasi tingkatan pramuka.',
          ),

          buildBullet(
            'Data Aktivitas',
            'Riwayat petualangan, lencana, dan progres materi.',
          ),

          buildBullet(
            'Lokasi',
            'Data GPS saat menggunakan fitur lokasi dan pelacakan.',
          ),
        ],
      ),
    );
  }

  Widget buildBullet(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_circle,
              color: Color(0xFF7D562D),
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF504442),
                  height: 1.5,
                ),

                children: [

                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextSpan(
                    text: subtitle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUsageSection() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7D562D),
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFCA98),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.visibility,
                  color: Color(0xFF7A532A),
                ),
              ),

              const SizedBox(width: 16),

              const Text(
                '3. Penggunaan Data',
                style: TextStyle(
                  color: Color(0xFF361F1A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Data yang kami kumpulkan digunakan untuk tujuan berikut:',
            style: TextStyle(
              color: Color(0xFF504442),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F3EE),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Personalisasi',
                        style: TextStyle(
                          color: Color(0xFF361F1A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Rekomendasi petualangan sesuai level pengguna.',
                        style: TextStyle(
                          color: Color(0xFF504442),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F3EE),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'Keamanan',
                        style: TextStyle(
                          color: Color(0xFF361F1A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Menjaga akun tetap aman dari akses ilegal.',
                        style: TextStyle(
                          color: Color(0xFF504442),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
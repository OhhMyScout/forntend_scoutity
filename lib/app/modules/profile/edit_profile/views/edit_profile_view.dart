import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const bgColor = Color(0xFFFCF9F4);
    const containerColor = Color(0xFFF0EDE9);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => controller.goBack(), // // Kembali
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            child: Column(
              children: [
                // Profile Picture Section
                _buildPhotoSection(),
                const SizedBox(height: 40),

                // Form Fields
                _buildTextField(
                  label: "Nama Lengkap",
                  controller: controller.nameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: "Email",
                  controller: controller.emailController,
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                _buildDropdownField("Provinsi"),
                const SizedBox(height: 24),
                _buildTextField(
                  label: "Gugus Depan",
                  controller: controller.unitController,
                  icon: Icons.corporate_fare_outlined,
                ),

                const SizedBox(height: 40),
                
                // Danger Zone
                const Divider(color: Color(0xFFD4C3BF)),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => controller.deleteAccount(), // // Hapus Akun
                  icon: const Icon(Icons.delete_forever, color: Color(0xFFBA1A1A)),
                  label: const Text(
                    "Hapus Akun Permanen",
                    style: TextStyle(color: Color(0xFFBA1A1A), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => controller.saveProfile(), // // Simpan
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 64,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAW_vEZrqIWA57KLjmikorI0PUCeJE65pcJC_640s-73uUZJlcOIvQwsUUPOHLbwW0PZZ78FWO90VAmSHpyM3gRR581vsewO5YlspodWnv9zXELUB_y0syWb4XLwqQICF_uE7AIGUXEaV2LoqxB7yVWFsrlqQzOXNJBLNIMLcZ-X7f3f4Gr20N88GGn8DheMk6wRCuEJVTkY6HSeR_zrT7t1KBuhwkRQDNlEwt_s4ez4S3FfS6_cQxXE-TCllOS1ZxvrXNHE8sXZlA'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => controller.pickImage(), // // Ganti Foto
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF361F1A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.photo_camera, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text("Ubah Foto Profil", style: TextStyle(color: Color(0xFF7D562D), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF361F1A))),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            fillColor: const Color(0xFFF6F3EE),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Icon(icon, color: const Color(0xFFD4C3BF)),
            hintText: "Masukkan $label",
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF361F1A))),
        ),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3EE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedProvince.value,
              isExpanded: true,
              icon: const Icon(Icons.expand_more, color: Color(0xFFD4C3BF)),
              onChanged: (String? newValue) {
                if (newValue != null) controller.selectedProvince.value = newValue;
              },
              items: controller.provinces.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        )),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF361F1A);
    const bg = Color(0xFFFCF9F4);

    return Scaffold(
      backgroundColor: bg,

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primary),
          onPressed: controller.goBack,
        ),
        title: const Text(
          "Edit Profil",
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
      ),

      // ================= BODY =================
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
              child: Column(
                children: [
                  _buildAvatar(),

                  const SizedBox(height: 30),

                  _cardField(
                    label: "Nama Lengkap",
                    child: _input(
                      controller: controller.nameController,
                      icon: Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _cardField(
                    label: "Email",
                    child: _input(
                      controller: controller.emailController,
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _cardField(
                    label: "Provinsi",
                    child: _dropdown(),
                  ),

                  const SizedBox(height: 16),

                  _cardField(
                    label: "Username",
                    child: _input(
                      controller: controller.usernameController,
                      icon: Icons.badge_outlined,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _cardField(
                    label: "Gugus Depan",
                    child: _input(
                      controller: controller.unitController,
                      icon: Icons.apartment_outlined,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextButton.icon(
                    onPressed: controller.deleteAccount,
                    icon: const Icon(Icons.delete_forever,
                        color: Color(0xFFBA1A1A)),
                    label: const Text(
                      "Hapus Akun Permanen",
                      style: TextStyle(
                        color: Color(0xFFBA1A1A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= SAVE BUTTON =================
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    )
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : _handleSaveWithOtp,
                    child: const Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // =====================================================
  // AVATAR
  // =====================================================
  Widget _buildAvatar() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFFF0EDE9),
              child: Icon(Icons.person, size: 55, color: Color(0xFF361F1A)),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: Color(0xFF361F1A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Ubah Foto Profil",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF7D562D),
          ),
        )
      ],
    );
  }

  // =====================================================
  // CARD FIELD
  // =====================================================
  Widget _cardField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF361F1A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3EE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: child,
        ),
      ],
    );
  }

  // =====================================================
  // INPUT
  // =====================================================
  Widget _input({
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(icon, color: Colors.grey),
      ),
    );
  }

  // =====================================================
  // DROPDOWN
  // =====================================================
  Widget _dropdown() {
    return Obx(
      () => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedProvince.value,
          isExpanded: true,
          icon: const Icon(Icons.expand_more),
          onChanged: controller.changeProvince,
          items: controller.provinces
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // =====================================================
  // OTP FLOW
  // =====================================================
  Future<void> _handleSaveWithOtp() async {
    final newEmail = controller.emailController.text.trim();
    final oldEmail = controller.box.read("email");

    if (newEmail != oldEmail) {
      await controller.requestOtp(newEmail);

      Get.defaultDialog(
        title: "Verifikasi Email",
        radius: 12,
        content: Column(
          children: [
            const Text("Masukkan kode OTP"),
            const SizedBox(height: 10),
            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "OTP",
              ),
            ),
          ],
        ),
        textConfirm: "Verifikasi",
        textCancel: "Batal",
        onConfirm: () async {
          final ok = await controller.verifyOtp(
            newEmail,
            controller.otpController.text.trim(),
          );

          if (ok) {
            Get.back();
            await controller.saveProfile();
          } else {
            Get.snackbar("Gagal", "OTP salah / expired");
          }
        },
      );
    } else {
      await controller.saveProfile();
    }
  }
}
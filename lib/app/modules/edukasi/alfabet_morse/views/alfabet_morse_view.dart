import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/alfabet_morse_controller.dart';

class AlfabetMorseView extends GetView<AlfabetMorseController> {
  const AlfabetMorseView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: controller.back,
        ),
        title: const Text("Alfabet Morse Lengkap", 
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideCard(primaryColor),
            const SizedBox(height: 32),
            _buildSectionTitle("Huruf (A-Z)", primaryColor),
            const SizedBox(height: 16),
            _buildGrid(controller.alfabetData, primaryColor, secondaryColor),
            const SizedBox(height: 40),
            _buildDivider("Angka (0-9)", primaryColor),
            const SizedBox(height: 24),
            _buildGrid(controller.angkaData, primaryColor, secondaryColor),
            const SizedBox(height: 60),
            Center(child: Opacity(opacity: 0.1, child: Icon(Icons.park, size: 100, color: primaryColor))),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: primary, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Panduan Cepat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary, fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          const Text("Sandi Morse menggunakan kode titik (.) dan garis (-) yang disusun mewakili karakter tertentu.",
            style: TextStyle(color: Colors.black54, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color primary) {
    return Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary, fontFamily: 'Poppins'));
  }

  Widget _buildDivider(String title, Color primary) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black12)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: primary)),
        ),
        Expanded(child: Divider(color: Colors.black12)),
      ],
    );
  }

  Widget _buildGrid(List<Map<String, String>> data, Color primary, Color secondary) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item['char']!, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primary, fontFamily: 'Poppins')),
              const SizedBox(height: 8),
              _buildMorseVisual(item['code']!, secondary),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMorseVisual(String code, Color color) {
    List<String> parts = code.split('');
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: parts.map((p) {
        return Container(
          width: p == '.' ? 8 : 20,
          height: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        );
      }).toList(),
    );
  }
}
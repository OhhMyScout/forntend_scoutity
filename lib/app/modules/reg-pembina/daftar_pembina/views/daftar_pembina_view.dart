import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/daftar_pembina_controller.dart';

class DaftarPembinaView extends GetView<DaftarPembinaController> {
  const DaftarPembinaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DaftarPembinaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DaftarPembinaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/daftar_antrian_validasi_controller.dart';

class DaftarAntrianValidasiView
    extends GetView<DaftarAntrianValidasiController> {
  const DaftarAntrianValidasiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DaftarAntrianValidasiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DaftarAntrianValidasiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

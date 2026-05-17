import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tabel_berita_provinsi_controller.dart';

class TabelBeritaProvinsiView extends GetView<TabelBeritaProvinsiController> {
  const TabelBeritaProvinsiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabelBeritaProvinsiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TabelBeritaProvinsiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

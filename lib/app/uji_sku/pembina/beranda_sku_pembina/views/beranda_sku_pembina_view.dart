import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/beranda_sku_pembina_controller.dart';

class BerandaSkuPembinaView extends GetView<BerandaSkuPembinaController> {
  const BerandaSkuPembinaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BerandaSkuPembinaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BerandaSkuPembinaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

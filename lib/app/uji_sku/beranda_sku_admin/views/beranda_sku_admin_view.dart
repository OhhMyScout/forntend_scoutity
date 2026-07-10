import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/beranda_sku_admin_controller.dart';

class BerandaSkuAdminView extends GetView<BerandaSkuAdminController> {
  const BerandaSkuAdminView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BerandaSkuAdminView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BerandaSkuAdminView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

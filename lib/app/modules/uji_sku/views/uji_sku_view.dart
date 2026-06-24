import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/uji_sku_controller.dart';

class UjiSkuView extends GetView<UjiSkuController> {
  const UjiSkuView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UjiSkuView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UjiSkuView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

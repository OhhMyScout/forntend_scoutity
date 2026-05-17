import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/kompas_controller.dart';

class KompasView extends GetView<KompasController> {
  const KompasView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KompasView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KompasView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

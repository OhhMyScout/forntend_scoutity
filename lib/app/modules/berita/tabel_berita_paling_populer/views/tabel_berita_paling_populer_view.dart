import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tabel_berita_paling_populer_controller.dart';

class TabelBeritaPalingPopulerView
    extends GetView<TabelBeritaPalingPopulerController> {
  const TabelBeritaPalingPopulerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabelBeritaPalingPopulerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TabelBeritaPalingPopulerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

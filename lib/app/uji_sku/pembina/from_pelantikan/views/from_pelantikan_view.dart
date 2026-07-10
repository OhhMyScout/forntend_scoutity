import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/from_pelantikan_controller.dart';

class FromPelantikanView extends GetView<FromPelantikanController> {
  const FromPelantikanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FromPelantikanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FromPelantikanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

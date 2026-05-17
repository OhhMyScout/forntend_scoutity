import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sejarah_pramuka_controller.dart';

class SejarahPramukaView extends GetView<SejarahPramukaController> {
  const SejarahPramukaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SejarahPramukaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SejarahPramukaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

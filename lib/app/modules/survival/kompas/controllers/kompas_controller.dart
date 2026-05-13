/// lib/app/modules/kompas/controllers/kompas_controller.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KompasController extends GetxController {

  /// Compass rotation
  final rotation = 145.0.obs;

  /// Direction text
  final direction = 'SE'.obs;

  /// Full direction
  final fullDirection = 'South East'.obs;

  /// Refresh / calibration simulation
  void refreshCompass() {

    final random =
        Random();

    final degree =
        random.nextInt(360).toDouble();

    rotation.value = degree;

    updateDirection(degree);

    Get.snackbar(
      'Kompas',
      'Kalibrasi berhasil',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateDirection(double degree) {

    if (degree >= 337.5 || degree < 22.5) {
      direction.value = 'N';
      fullDirection.value = 'North';
    }

    else if (degree >= 22.5 && degree < 67.5) {
      direction.value = 'NE';
      fullDirection.value = 'North East';
    }

    else if (degree >= 67.5 && degree < 112.5) {
      direction.value = 'E';
      fullDirection.value = 'East';
    }

    else if (degree >= 112.5 && degree < 157.5) {
      direction.value = 'SE';
      fullDirection.value = 'South East';
    }

    else if (degree >= 157.5 && degree < 202.5) {
      direction.value = 'S';
      fullDirection.value = 'South';
    }

    else if (degree >= 202.5 && degree < 247.5) {
      direction.value = 'SW';
      fullDirection.value = 'South West';
    }

    else if (degree >= 247.5 && degree < 292.5) {
      direction.value = 'W';
      fullDirection.value = 'West';
    }

    else {
      direction.value = 'NW';
      fullDirection.value = 'North West';
    }
  }
}
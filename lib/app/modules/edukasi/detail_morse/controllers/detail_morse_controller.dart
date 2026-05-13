// lib/app/modules/detail_morse/controllers/detail_morse_controller.dart
import 'package:get/get.dart';

class DetailMorseController extends GetxController {
  final alfabetMorse = [
    {"char": "A", "code": ". -"},
    {"char": "B", "code": "- . . ."},
    {"char": "C", "code": "- . - ."},
    {"char": "D", "code": "- . ."},
    {"char": "E", "code": "."},
    {"char": "S", "code": ". . ."},
    {"char": "O", "code": "- - -"},
    {"char": "M", "code": "- -"},
  ].obs;

  final angkaMorse = [
    {"char": "1", "code": ". - - - -"},
    {"char": "0", "code": "- - - - -"},
  ].obs;

  void back() => Get.back();
}
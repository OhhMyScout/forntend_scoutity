import 'package:get/get.dart';

class AlfabetMorseController extends GetxController {
  // Data Alfabet A-Z
  final List<Map<String, String>> alfabetData = [
    {"char": "A", "code": ".-"},    {"char": "B", "code": "-..."},
    {"char": "C", "code": "-.-."},  {"char": "D", "code": "-.."},
    {"char": "E", "code": "."},     {"char": "F", "code": "..-."},
    {"char": "G", "code": "--."},   {"char": "H", "code": "...."},
    {"char": "I", "code": ".."},    {"char": "J", "code": ".---"},
    {"char": "K", "code": "-.-"},   {"char": "L", "code": ".-.."},
    {"char": "M", "code": "--"},    {"char": "N", "code": "-."},
    {"char": "O", "code": "---"},   {"char": "P", "code": ".--."},
    {"char": "Q", "code": "--.-"},  {"char": "R", "code": ".-."},
    {"char": "S", "code": "..."},   {"char": "T", "code": "-"},
    {"char": "U", "code": "..-"},   {"char": "V", "code": "...-"},
    {"char": "W", "code": ".--"},   {"char": "X", "code": "-..-"},
    {"char": "Y", "code": "-.--"},  {"char": "Z", "code": "--.."},
  ];

  // Data Angka 0-9
  final List<Map<String, String>> angkaData = [
    {"char": "1", "code": ".----"}, {"char": "2", "code": "..---"},
    {"char": "3", "code": "...--"}, {"char": "4", "code": "....-"},
    {"char": "5", "code": "....."}, {"char": "6", "code": "-...."},
    {"char": "7", "code": "--..."}, {"char": "8", "code": "---.."},
    {"char": "9", "code": "----."}, {"char": "0", "code": "-----"},
  ];

  void back() => Get.back();
}
import 'package:get/get.dart';

class BertahanHidupController extends GetxController {
  
  // State untuk melacak accordion mana yang sedang terbuka.
  // Nilai -1 berarti tidak ada yang terbuka.
  var activeAccordionIndex = (-1).obs;

  void toggleAccordion(int index) {
    if (activeAccordionIndex.value == index) {
      // Jika yang di-klik sudah terbuka, maka tutup
      activeAccordionIndex.value = -1;
    } else {
      // Jika yang lain di-klik, buka yang ini (yang lama otomatis tertutup)
      activeAccordionIndex.value = index;
    }
  }

  void onBack() {
    Get.back();
  }
}
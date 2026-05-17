import 'package:get/get.dart';

class DetailP3KController extends GetxController {
  // Penampung data argumen reaktif
  var title = ''.obs;
  var steps = <String>[].obs;
  var proTip = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      title.value = args['title'] ?? 'Detail Penanganan';
      steps.value = List<String>.from(args['steps'] ?? []);
      proTip.value = args['pro_tip'] ?? '';
    }
  }

  void onBack() {
    Get.back();
  }
}
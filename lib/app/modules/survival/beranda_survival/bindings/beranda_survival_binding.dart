import 'package:get/get.dart';
import '../controllers/beranda_survival_controller.dart';

class BerandaSurvivalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaSurvivalController>(() => BerandaSurvivalController());
  }
}
import 'package:get/get.dart';
import '../controllers/p3k_checklist_controller.dart';

class P3KChecklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<P3KChecklistController>(
      () => P3KChecklistController(),
    );
  }
}
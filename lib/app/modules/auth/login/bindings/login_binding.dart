import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    //update login view with new design and layout
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}

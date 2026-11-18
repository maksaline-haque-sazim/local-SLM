import 'package:flutter_getx_starter_template/routes.dart';
import 'package:flutter_getx_starter_template/shared/services/auth.service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  void openCreateProduct() {
    Get.toNamed(Routes.createProduct);
  }

  Future<void> logout() async {
    await AuthService.instance.logoutWithoutRefreshToken();
    Get.offAllNamed(Routes.login);
  }
}

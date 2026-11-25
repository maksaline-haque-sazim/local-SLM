import 'package:flutter_getx_starter_template/routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  void openChat() {
    Get.toNamed(Routes.chat);
  }
}

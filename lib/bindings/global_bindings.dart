import 'package:flutter_getx_starter_template/network/service/api_client.service.dart';
import 'package:flutter_getx_starter_template/shared/services/auth.service.dart';
import 'package:flutter_getx_starter_template/shared/services/token.service.dart';
import 'package:flutter_getx_starter_template/utils/managers/network_manager.dart';
import 'package:get/get.dart';

class GlobalBindings extends Bindings {
  GlobalBindings({this.enableApiGlobalLogging = false});

  final bool enableApiGlobalLogging;

  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(TokenService()..init());
    Get.put(ApiClientService()..init(enableGlobalLogging: enableApiGlobalLogging));
    Get.put(AuthService());
  }
}

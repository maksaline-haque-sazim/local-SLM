import 'package:flutter_getx_starter_template/features/products/controllers/create_product_controller.dart';
import 'package:flutter_getx_starter_template/shared/services/product.service.dart';
import 'package:get/get.dart';

class CreateProductBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProductService>()) {
      Get.lazyPut<ProductService>(() => ProductService());
    }
    Get.lazyPut<CreateProductController>(() => CreateProductController());
  }
}

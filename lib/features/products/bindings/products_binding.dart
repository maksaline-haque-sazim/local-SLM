import 'package:flutter_getx_starter_template/features/products/controllers/products_controller.dart';
import 'package:flutter_getx_starter_template/shared/services/product.service.dart';
import 'package:get/get.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProductService>()) {
      Get.lazyPut<ProductService>(() => ProductService());
    }

    Get.lazyPut<ProductsController>(() => ProductsController());
  }
}


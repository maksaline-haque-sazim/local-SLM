import 'package:flutter_getx_starter_template/data/dto_models/create_product_dto.dart';
import 'package:flutter_getx_starter_template/data/dto_models/update_product_dto.dart';
import 'package:flutter_getx_starter_template/domain/entitys/product_entity.dart';
import 'package:flutter_getx_starter_template/shared/services/product.service.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  static ProductsController get instance => Get.find();

  final ProductService _productService = ProductService.instance;

  List<ProductEntity> get products => _productService.products;
  bool get isLoading => _productService.isLoading.value;
  ProductEntity? get selectedProduct => _productService.selectedProduct.value;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      await _productService.fetchProducts(page: 1, limit: 20);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> viewProduct(String id) async {
    try {
      await _productService.getProduct(id);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
  }) async {
    try {
      final dto = CreateProductDto(
        name: name,
        description: description,
        price: price,
        stock: stock,
      );

      await _productService.createProduct(dto);

      Get.snackbar(
        'Success',
        'Product created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProduct(
    String id, {
    String? name,
    String? description,
    double? price,
    int? stock,
  }) async {
    try {
      final dto = UpdateProductDto(
        name: name,
        description: description,
        price: price,
        stock: stock,
      );

      await _productService.updateProduct(id, dto);

      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _productService.deleteProduct(id);
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<ProductEntity> get inStockProducts => _productService.inStockProducts;

  List<ProductEntity> get lowStockProducts => _productService.lowStockProducts;
}


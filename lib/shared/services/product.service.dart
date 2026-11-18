import 'package:flutter_getx_starter_template/data/dto_models/create_product_dto.dart';
import 'package:flutter_getx_starter_template/data/dto_models/update_product_dto.dart';
import 'package:flutter_getx_starter_template/data/repositories/product_repository.dart';
import 'package:flutter_getx_starter_template/domain/abstract_repositories/abstract_product_repository.dart';
import 'package:flutter_getx_starter_template/domain/entitys/product_entity.dart';
import 'package:get/get.dart';

class ProductService extends GetxService {
  static ProductService get instance => Get.find<ProductService>();

  final AbstractProductRepository _repository = ProductRepository();

  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final Rx<ProductEntity?> selectedProduct = Rx<ProductEntity?>(null);
  final RxBool isLoading = false.obs;

  Future<void> fetchProducts({int page = 1, int limit = 10}) async {
    try {
      isLoading.value = true;
      final fetchedProducts = await _repository.getAllProducts(page: page, limit: limit);
      products.value = fetchedProducts;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<ProductEntity> getProduct(String id) async {
    try {
      isLoading.value = true;
      final product = await _repository.getProductById(id);
      selectedProduct.value = product;
      return product;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<ProductEntity> createProduct(CreateProductDto createProductDto) async {
    try {
      isLoading.value = true;
      final newProduct = await _repository.createProduct(createProductDto);
      products.add(newProduct);
      return newProduct;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<ProductEntity> updateProduct(String id, UpdateProductDto updateProductDto) async {
    try {
      isLoading.value = true;
      final updatedProduct = await _repository.updateProduct(id, updateProductDto);

      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = updatedProduct;
      }

      return updatedProduct;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      isLoading.value = true;
      await _repository.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductEntity> get inStockProducts {
    return products.where((p) => p.isInStock).toList();
  }

  List<ProductEntity> get lowStockProducts {
    return products.where((p) => p.isLowStock).toList();
  }
}


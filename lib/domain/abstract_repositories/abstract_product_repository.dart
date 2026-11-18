import 'package:flutter_getx_starter_template/data/dto_models/create_product_dto.dart';
import 'package:flutter_getx_starter_template/data/dto_models/update_product_dto.dart';
import 'package:flutter_getx_starter_template/domain/entitys/product_entity.dart';

abstract class AbstractProductRepository {
  Future<ProductEntity> getProductById(String id);

  Future<List<ProductEntity>> getAllProducts({int page = 1, int limit = 10});

  Future<ProductEntity> createProduct(CreateProductDto createProductDto);

  Future<ProductEntity> updateProduct(String id, UpdateProductDto updateProductDt);

  Future<void> deleteProduct(String id);
}


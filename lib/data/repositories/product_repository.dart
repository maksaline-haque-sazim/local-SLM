import 'package:flutter_getx_starter_template/data/dto_models/create_product_dto.dart';
import 'package:flutter_getx_starter_template/data/dto_models/update_product_dto.dart';
import 'package:flutter_getx_starter_template/data/response_model/product_response_model.dart';
import 'package:flutter_getx_starter_template/domain/abstract_repositories/abstract_product_repository.dart';
import 'package:flutter_getx_starter_template/domain/entitys/product_entity.dart';
import 'package:flutter_getx_starter_template/network/api_endpoints.dart';
import 'package:flutter_getx_starter_template/network/repository/base_repository.dart';

class ProductRepository extends BaseRepository
    implements AbstractProductRepository {
  @override
  Future<ProductEntity> getProductById(String id) async {
    final response = await getRequest(
      '${ApiEndpoints.products}/$id',
      enableLog: true,
    );

    final model = ProductResponseModel.fromJson(response.body);
    return model.toEntity();
  }

  @override
  Future<List<ProductEntity>> getAllProducts({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await getRequest(
      ApiEndpoints.products,
      query: {'page': page, 'limit': limit},
      enableLog: true,
    );

    final models = ProductResponseModel.fromJsonList(
      response.body['data'] as List,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ProductEntity> createProduct(CreateProductDto createProductDto) async {
    final response = await postRequest(
      ApiEndpoints.products,
      createProductDto.toJson(),
      enableLog: true,
    );

    final model = ProductResponseModel.fromJson(response.body);
    return model.toEntity();
  }

  @override
  Future<ProductEntity> updateProduct(
    String id,
    UpdateProductDto updateProductDto,
  ) async {
    final response = await patchRequest(
      '${ApiEndpoints.products}/$id',
      updateProductDto.toJson(),
      enableLog: true,
    );

    final model = ProductResponseModel.fromJson(response.body);
    return model.toEntity();
  }

  @override
  Future<void> deleteProduct(String id) async {
    await deleteRequest('${ApiEndpoints.products}/$id', enableLog: true);
  }
}

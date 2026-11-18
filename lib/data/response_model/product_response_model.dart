import 'package:flutter_getx_starter_template/domain/entitys/product_entity.dart';

class ProductResponseModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String createdAt;

  ProductResponseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      createdAt: json['createdAt'] as String,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      createdAt: DateTime.parse(createdAt),
    );
  }

  static List<ProductResponseModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductResponseModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}


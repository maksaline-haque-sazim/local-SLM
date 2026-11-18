class UpdateProductDto {
  final String? name;
  final String? description;
  final double? price;
  final int? stock;

  UpdateProductDto({
    this.name,
    this.description,
    this.price,
    this.stock,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (stock != null) data['stock'] = stock;

    return data;
  }
}


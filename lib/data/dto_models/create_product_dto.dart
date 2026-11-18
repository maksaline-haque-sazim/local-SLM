class CreateProductDto {
  final String name;
  final String description;
  final double price;
  final int stock;

  CreateProductDto({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
    };
  }
}


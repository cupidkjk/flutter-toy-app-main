class ProductModel {
  final String id;
  final String name;
  final String description;
  final String excerpt;
  final double price;
  final int stock;
  final String image;
  final String category;
  ProductModel(
      {this.id,
      this.name,
      this.description,
      this.excerpt,
      this.price,
      this.stock,
      this.image,
      this.category});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double _price = double.parse(json['price'].toString());
    return ProductModel(
        id: json['_id'],
        name: json['name'],
        description: json['description'] ?? "",
        excerpt: json['excerpt'] ?? "",
        price: _price ?? 0.0,
        image: json['image'] ?? "",
        stock: json['stock'] ?? 0,
        category: json['category']['name'] ?? "");
  }
}

class Product {
  final String id;
  final String name;
  final int price;
  final int stock;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
  });

  factory Product.fromDocument(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      stock: data['stock'] ?? 0,
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
      'description': description,
      'createdAt': DateTime.now(),
    };
  }
}

class Product {
  final int productId;
  final int quantity;
  final String image;

  Product(
      {required this.productId, required this.quantity, required this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['ProductID'],
      quantity: json['Quantity'],
      image: json['Image'],
    );
  }
}

class Order {
  final int orderId;
  final num total;
  final String status;
  final DateTime createdAt;
  final List<Product> products;

  Order(
      {required this.orderId,
      required this.total,
      required this.status,
      required this.createdAt,
      required this.products});

  factory Order.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<Product> products =
        productList.map((i) => Product.fromJson(i)).toList();

    return Order(
      orderId: json['OrderID'],
      total: json['Total'],
      status: json['Status'],
      createdAt: DateTime.parse(json['CreatedAt']),
      products: products,
    );
  }
}

class CatalogProduct {
  final String productId;
  final String productName;
  final double price; // Ensure `price` is a double
  final double? onsale_price; // Make onsale_price nullable
  final String productModel;
  final String photo;

  CatalogProduct({
    required this.productId,
    required this.productName,
    required this.price, // Adjust type to double
    this.onsale_price, // Nullable field
    required this.productModel,
    required this.photo,
  });

  // Factory method to create a CatalogProduct from JSON
  factory CatalogProduct.fromJson(Map<String, dynamic> json) {
    return CatalogProduct(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0, // Safely parse price
      onsale_price: json['onsale_price'] != null
          ? double.tryParse(json['onsale_price'].toString())
          : null, // Safely parse onsale_price
      productModel: json['product_model'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}

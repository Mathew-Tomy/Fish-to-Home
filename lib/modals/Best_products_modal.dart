class BestProducts {
  final String? productId;  // Keep productId as String
  final String productName;
  // final String price;  // Keep price as String
  final String imageThumb;
  final String productModel;
  // Add other fields as needed

  // Constructor with named parameters
  BestProducts({
    required this.productId,
    required this.productName,
    // required this.price,
    required this.imageThumb,
    required this.productModel,
  });

  // Factory constructor for creating an instance from JSON
  factory BestProducts.fromJson(Map<String, dynamic> json) {
    return BestProducts(
      productId: json['product_id']?.toString(),
      productName: json['product_name'] ?? '',  // Handle null product_name
      // price: json['price']?.toString() ?? '0',  // Ensure price is a String
      imageThumb: json['image_thumb'] ?? '',  // Handle null image_thumb
      productModel: json['product_model'] ?? '',  // Handle null product_model
    );
  }

  // Method to convert the object to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      // 'price': price,
      'image_thumb': imageThumb,
      'product_model': productModel,
    };
  }
}

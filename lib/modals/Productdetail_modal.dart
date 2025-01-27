class Productsmodal {
  String? productId;
  String? productName;
  String? categoryId;
  String? categoryName;
  String? productModel;
  double? price;  // price can be a string in the API response, but it should be treated as a double
  double? supplierPrice;
  String? unit;
  String? productDetails;
  String? imageThumb;
  String? brandId;
  String? variants;
  String? defaultVariant;
  String? type;
  bool? bestSale;  // best_sale is represented as "1" or "0", so it will be boolean
  bool? featured;
  bool? onsale;
  double? onsalePrice;  // onsale_price can be a string in the API response, so it should be treated as a double
  String? invoiceDetails;
  String? imageLargeDetails;
  String? review;
  String? description;
  String? tag;
  String? specification;
  String? stock;
  int? status;  // status is represented as "1" or "0", so it will be an integer

  Productsmodal({
    this.productId,
    this.productName,
    this.categoryId,
    this.categoryName,
    this.productModel,
    this.price,
    this.supplierPrice,
    this.unit,
    this.productDetails,
    this.imageThumb,
    this.brandId,
    this.variants,
    this.defaultVariant,
    this.type,
    this.bestSale,
    this.featured,
    this.onsale,
    this.onsalePrice,
    this.invoiceDetails,
    this.imageLargeDetails,
    this.review,
    this.description,
    this.tag,
    this.specification,
    this.stock,
    this.status,
  });

  Productsmodal.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'].toString();  // Ensure product_id is a String
    productName = json['product_name'];
    categoryId = json['category_id'].toString();  // Ensure category_id is a String
    categoryName = json['category_name'];
    productModel = json['product_model'];
    price = json['price'] != null ? double.tryParse(json['price'].toString()) : null;  // Handle price as double
    supplierPrice = json['supplier_price'] != null ? double.tryParse(json['supplier_price'].toString()) : null;  // Handle supplier_price as double
    unit = json['unit'];
    productDetails = json['product_details'];
    imageThumb = json['image_thumb'];
    brandId = json['brand_id'];
    variants = json['variants'];
    defaultVariant = json['default_variant'];
    type = json['type'];
    bestSale = json['best_sale'] == "1";  // Convert "1" or "0" to boolean
    featured = json['featured'] == "1";  // Convert "1" or "0" to boolean
    onsale = json['onsale'] == "1";  // Convert "1" or "0" to boolean
    onsalePrice = json['onsale_price'] != null ? double.tryParse(json['onsale_price'].toString()) : null;  // Handle onsale_price as double
    invoiceDetails = json['invoice_details'];
    imageLargeDetails = json['image_large_details'];
    review = json['review'];
    description = json['description'];
    tag = json['tag'];
    specification = json['specification'];
    stock = json['stock'];
    status = json['status'] != null ? int.tryParse(json['status'].toString()) : null;  // Convert status to integer
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['product_model'] = this.productModel;
    data['price'] = this.price;
    data['supplier_price'] = this.supplierPrice;
    data['unit'] = this.unit;
    data['product_details'] = this.productDetails;
    data['image_thumb'] = this.imageThumb;
    data['brand_id'] = this.brandId;
    data['variants'] = this.variants;
    data['default_variant'] = this.defaultVariant;
    data['type'] = this.type;
    data['best_sale'] = this.bestSale == true ? "1" : "0";  // Convert boolean back to "1" or "0"
    data['featured'] = this.featured == true ? "1" : "0";  // Convert boolean back to "1" or "0"
    data['onsale'] = this.onsale == true ? "1" : "0";  // Convert boolean back to "1" or "0"
    data['onsale_price'] = this.onsalePrice;
    data['invoice_details'] = this.invoiceDetails;
    data['image_large_details'] = this.imageLargeDetails;
    data['review'] = this.review;
    data['description'] = this.description;
    data['tag'] = this.tag;
    data['specification'] = this.specification;
    data['stock'] = this.stock;
    data['status'] = this.status;
    return data;
  }
}

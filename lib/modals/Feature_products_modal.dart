class FeatureProduct {
  String? photo;
  String? productName;
  int? price;
  int? productId;
  String? type;
  String? Meta_keywords;

  // Fetching product details



  FeatureProduct({this.photo, this.productName, this.price, this.productId, this.type,this.Meta_keywords});

  FeatureProduct.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    productName = json['product_name']; // Updated property name
    price = json['price'];
    productId = json['product_id'];
    type = json['type'];
    Meta_keywords=json['meta_keywords'];
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['product_name'] = productName; // Updated key name
    data['price'] = price;
    data['product_id'] = productId;
    data['type'] = type;
    data['meta_keywords']= Meta_keywords;
    return data;
  }
  // Method to truncate the product name


}


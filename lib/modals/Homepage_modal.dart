
class Homepage {
  String? feature;
  String? top;
  String? special;
  String? best;

  Homepage({
    this.feature,
    this.top,
    this.special,
    this.best,
  });

  factory Homepage.fromJson(Map<String, dynamic> json) {
    return Homepage(
      feature: json['feature'] as String?,
      best: json['best'] as String?,
      special: json['special'] as String?,
      top: json['top'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (top != null) data['top'] = top;
    if (feature != null) data['feature'] = feature;
    if (special != null) data['special'] = special;
    if (best != null) data['best'] = best;
    return data;
  }
}


class Products {
  String? productId;
  String? productName;
  String? categoryName;
  int? categoryId;
  String? subcategoryName;
  int? totalStock;
  int? attributeStock;
  int? optionId;
  String? color;
  String? size;
  int? subcategoryId;
  int? childcategoryId;
  String? brand;
  String? slug;
  String? sortDetails;
  String? photo;
  String? code;
  String? type;
  double? price;

  Products({
    this.productId,
    this.productName,
    this.categoryName,
    this.categoryId,
    this.subcategoryName,
    this.totalStock,
    this.attributeStock,
    this.optionId,
    this.color,
    this.size,
    this.subcategoryId,
    this.childcategoryId,
    this.brand,
    this.slug,
    this.sortDetails,
    this.photo,
    this.code,
    this.type,
    this.price,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['product_id'],
      productName: json['product_name'],
      categoryName: json['category_name'],
      categoryId: json['category_id'],
      subcategoryName: json['subcategory_name'],
      totalStock: json['total_stock'],
      attributeStock: json['attribute_stock'],
      optionId: json['option_id'],
      color: json['color'],
      size: json['size'],
      subcategoryId: json['subcategory_id'],
      childcategoryId: json['childcategory_id'],
      brand: json['brand'],
      slug: json['slug'],
      sortDetails: json['sort_details'],
      photo: json['photo'],
      code: json['code'],
      type: json['type'],
      price: json['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    data['subcategory_name'] = subcategoryName;
    data['total_stock'] = totalStock;
    data['attribute_stock'] = attributeStock;
    data['option_id'] = optionId;
    data['color'] = color;
    data['size'] = size;
    data['subcategory_id'] = subcategoryId;
    data['childcategory_id'] = childcategoryId;
    data['brand'] = brand;
    data['slug'] = slug;
    data['sort_details'] = sortDetails;
    data['photo'] = photo;
    data['code'] = code;
    data['type'] = type;
    data['price'] = price;
    return data;
  }
}

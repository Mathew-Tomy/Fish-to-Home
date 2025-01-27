class Categoryproductmodal {
  List<Products> ?products;

  Categoryproductmodal({this.products});

  Categoryproductmodal.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Products>.empty();
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productId;
  String? photo;
  String? name;
  double? onsale_price;
  double? price;  // Change price type to double to handle string values like "75" and "59.95"
  String? categoryId;

  Products({
    this.productId,
    this.photo,
    this.name,
    this.price,
    this.onsale_price,
    this.categoryId,
  });

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    photo = json['photo']; // Using 'image_thumb' as the photo field
    name = json['name'];
    price = json['price'] != null ? double.tryParse(json['price'].toString()) : null;  // Parse the price as double
    onsale_price = json['onsale_price'] != null ? double.tryParse(json['onsale_price'].toString()) : null;
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = this.productId;
    data['photo'] = this.photo;
    data['name'] = this.name;
    data['price'] = this.price?.toString();  // Convert price back to string when sending data
    data['onsale_price'] = this.onsale_price?.toString();
    data['category_id'] = this.categoryId;
    return data;
  }
}


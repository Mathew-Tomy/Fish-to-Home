class Favourites {
  List<Products>? products;

  Favourites({this.products});

  Favourites.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[]; // Initialize the list
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productId;
  String? photo;
  String? productName;
  double? price;
  double? onsalePrice;

  Products({
    this.productId,
    this.photo,
    this.productName,
    this.price,
    this.onsalePrice,
  });

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    photo = json['photo'];
    productName = json['product_name'];
    price = json['price'] != null ? double.tryParse(json['price'].toString()) : null;
    onsalePrice = json['onsale_price'] != null ? double.tryParse(json['onsale_price'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['photo'] = photo;
    data['product_name'] = productName;
    data['price'] = price?.toString();
    data['onsale_price'] = onsalePrice?.toString();
    return data;
  }
}

class Cartproductmodal {
  List<Products>? products;

  Cartproductmodal({this.products});

  Cartproductmodal.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Products>.empty();
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

  double getTotalSum() {
    double totalSum = 0.0;
    if (products != null) {
      for (Products product in products!) {
        totalSum += double.parse(product.total ?? '0');
      }
    }
    return totalSum;
  }
}
class Products {
  dynamic cart_id;
  String? photo;
  dynamic product_id;
  String? product_name;
  String? product_model;
  String? quantity;
  String? variant_name;
  String? onsale_price;
  String? price;
  dynamic total; // Update the type to dynamic

  Products({
    this.cart_id,
    this.photo,
    this.product_id,
    this.product_name,
    this.product_model,
    this.quantity,
    this.variant_name,
    this.price,
    this.total, // Update the type here as well
    this.onsale_price,
  });

  Products.fromJson(Map<String, dynamic> json) {
    cart_id = json['cart_id'];
    photo = json['photo'];
    product_id = json['product_id'];
    product_name = json['product_name'];
    product_model = json['product_model'];
    quantity = json['quantity'];
    variant_name = json['variant_name'];
    price = json['price'];
    // Handle both int and String types for the total field
    total = json['total'].toString();
    onsale_price = json['onsale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cart_id;
    data['photo'] = photo;
    data['product_id'] = product_id;
    data['product_name'] = product_name;
    data['product_model'] = product_model;
    data['quantity'] = quantity;
    data['variant_name'] = variant_name;
    data['price'] = price;
    data['total'] = total; // No need to cast to String here
    data['onsale_price'] = onsale_price;
    return data;
  }
}




class Totals {
  String ?title;

  Totals({this.title});


}

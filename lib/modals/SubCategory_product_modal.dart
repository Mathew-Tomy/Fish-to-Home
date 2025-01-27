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
  int ?productId;
  String ?photo;
  String ?name;
  int? price;


  Products(
      {this.productId,
        this.photo,
        this.name,
        this.price,
      });

  Products.fromJson(Map<dynamic, dynamic> json) {
    productId = json['product_id'];
    photo = json['photo'];
    name = json['product_name'];
    price = json['price'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['photo'] = this.photo;
    data['product_name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class Hotdealsproducts {
  String ?success;
  String ?apiToken;
  Featured ?featured;

  Hotdealsproducts({this.success, this.apiToken, this.featured});

  Hotdealsproducts.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    apiToken = json['api_token'];
    featured = json['featured'] != null
        ? new Featured.fromJson(json['featured'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['api_token'] = this.apiToken;
    if (this.featured != null) {
      data['featured'] = this.featured!.toJson();
    }
    return data;
  }
}

class Featured {
  List<Null> ?layoutModules;
  List<ProductsHotdeal> ?products;
  int ?module;

  Featured({this.layoutModules, this.products, this.module});

  Featured.fromJson(Map<String, dynamic> json) {

    if (json['products'] != null) {
      products = new List<ProductsHotdeal>.empty();
      json['products'].forEach((v) {
        products!.add(new ProductsHotdeal.fromJson(v));
      });
    }
    module = json['module'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.layoutModules != null) {

    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['module'] = this.module;
    return data;
  }
}


class ProductsHotdeal {
  String? productId;
  String? productName;
  String? slug;
  String? sortDetails;
  String? photo;
  String? code;
  String? type;
  String? price;
  String? href;
  String ?option_id;


  ProductsHotdeal({
    this.productId,
    this.productName,
    this.slug,
    this.sortDetails,
    this.photo,
    this.code,
    this.type,
    this.price,
    this.href,
    this.option_id,
  });

  ProductsHotdeal.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'].toString();
    productName = json['product_name'];
    slug = json['slug'];
    sortDetails = json['sort_details'];
    photo = json['photo'];
    code = json['code'];
    type = json['type'];
    price = json['price'].toString();
    href = json['href'];
    href = json['option_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['slug'] = slug;
    data['sort_details'] = sortDetails;
    data['photo'] = photo;
    data['code'] = code;
    data['type'] = type;
    data['price'] = price;
    data['href'] = href;
    data['option_id'] = option_id;
    return data;
  }
}


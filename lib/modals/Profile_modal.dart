class Profile {

  List<Customer>? customer;

  Profile({this.customer});

  Profile.fromJson(Map<String, dynamic> json) {

    if (json['customer'] != null) {
      customer = <Customer>[];
      json['customer'].forEach((v) {
        customer!.add(new Customer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.customer != null) {
      data['customer'] = this.customer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  int? customerId; // Change String? to int?
  String? firstname;
  String? lastname;
  String? email;
  String? telephone;
  int? orders;
  int? returns;
  int? cart;
  int? wishlist;
  String? image;

  Customer({
    this.customerId,
    this.firstname,
    this.lastname,
    this.email,
    this.telephone,
    this.orders,
    this.returns,
    this.cart,
    this.wishlist,
    this.image,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId']; // Corrected key
    firstname = json['first_name'];
    lastname = json['last_name'];
    email = json['email'];
    telephone = json['phone'];
    orders = json['orders'];
    returns = json['returns'];
    cart = json['cart'];
    wishlist = json['wishlist'];
    image = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId; // Corrected key
    data['first_name'] = firstname;
    data['last_name'] = lastname;
    data['email'] = email;
    data['phone'] = telephone;
    data['orders'] = orders;
    data['returns'] = returns;
    data['cart'] = cart;
    data['wishlist'] = wishlist;
    data['photo'] = image;
    return data;
  }
}

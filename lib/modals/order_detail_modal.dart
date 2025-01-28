class OrderDetail {
  Order? order;
  List<Product>? products;

  OrderDetail({this.order, this.products});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Order {
  String? orderId;
  String? status;
  double? subTotal;
  String? serviceAmount;
  String? totalAmount;
  String? orderDate;
  String? customerName;
  String? customerShortAddress;
  String? customerAddress1;
  String? customerAddress2;
  String? customerMobile;
  String? customerEmail;
  String? paymentMethod;
  String? zip;
  List<Product>? products;  // Add this field

  Order({
    this.orderId,

    this.status,
    this.subTotal,
    this.serviceAmount,
    this.totalAmount,
    this.orderDate,
    this.customerName,
    this.customerShortAddress,
    this.customerAddress1,
    this.customerAddress2,
    this.customerMobile,
    this.customerEmail,
    this.paymentMethod,
    this.zip,
    this.products,  // Add this to constructor
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    status = json['status'];
    subTotal = json['Sub-Total']?.toDouble();
    serviceAmount = json['service_amount'];
    totalAmount = json['total_amount'];
    orderDate = json['order_date'];
    customerName = json['customer_name'];
    customerShortAddress = json['customer_short_address'];
    customerAddress1 = json['customer_address_1'];
    customerAddress2 = json['customer_address_2'];
    customerMobile = json['customer_mobile'];
    customerEmail = json['customer_email'];
    paymentMethod = json['paymentMethod'];
    zip = json['zip'];
    // Parse the list of products
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
    // Parse products

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['order_id'] = orderId;
    data['status'] = status;
    data['Sub-Total'] = subTotal;
    data['service_amount'] = serviceAmount;
    data['total_amount'] = totalAmount;
    data['order_date'] = orderDate;
    data['customer_name'] = customerName;
    data['customer_short_address'] = customerShortAddress;
    data['customer_address_1'] = customerAddress1;
    data['customer_address_2'] = customerAddress2;
    data['customer_mobile'] = customerMobile;
    data['customer_email'] = customerEmail;
    data['paymentMethod'] = paymentMethod;
    data['zip'] = zip;
    // Add products to JSON
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    // Add products to JSON


    return data;
  }

}

class Product {
  String? productId;
  String? productModel;
  String? productName;
  String? quantity;
  String? price;
  String? totalPrice;
  String? onsale_price;

  Product({
    this.productId,
    this.productModel,
    this.productName,
    this.quantity,
    this.price,
    this.totalPrice,
    this.onsale_price,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productModel=json['productModel'];
    productName = json['product_name'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
    onsale_price = json['onsale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = productId;
    data['productModel']=productModel;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['onsale_price'] = onsale_price;
    return data;
  }
}




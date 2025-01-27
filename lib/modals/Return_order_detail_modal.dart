class ReturnProduct {
  List<ProductsReturn>? productsReturn;

  ReturnProduct({this.productsReturn});

  ReturnProduct.fromJson(Map<String, dynamic> json) {
    if (json['productsReturn'] != null) {
      productsReturn = <ProductsReturn>[];
      json['productsReturn'].forEach((v) {
        productsReturn!.add(ProductsReturn.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (productsReturn != null) {
      data['productsReturn'] = productsReturn!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsReturn {
  int? productId;
  String? productName;
  int? orderProductId;
  int? optionId;
  int? returnQty;
  String? productPrice;
  int? remainingPrice;
  String? size;
  String? color;
  int? orderId;
  String? dateOrdered;
  String? transactionNumber;
  String? status;
  String? createdAt;
  String? returnReason;
  String? paymentMethod;
  String? paymentStatus;

  ProductsReturn({
    this.productId,
    this.productName,
    this.orderProductId,
    this.optionId,
    this.returnQty,
    this.productPrice,
    this.remainingPrice,
    this.size,
    this.color,
    this.orderId,
    this.dateOrdered,
    this.transactionNumber,
    this.status,
    this.createdAt,
    this.returnReason,
    this.paymentMethod,
    this.paymentStatus,
  });

  ProductsReturn.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    orderProductId = json['order_product_id'];
    optionId = json['option_id'];
    returnQty = json['return_qty'];
    productPrice = json['product_price'];
    remainingPrice = json['remaining_price'];
    size = json['size'];
    color = json['color'];
    orderId = json['orderId'];
    dateOrdered = json['date_ordered'];
    transactionNumber = json['transaction_number'];
    status = json['status'];
    createdAt = json['created_at'];
    returnReason = json['return_reason'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['order_product_id'] = orderProductId;
    data['option_id'] = optionId;
    data['return_qty'] = returnQty;
    data['product_price'] = productPrice;
    data['remaining_price'] = remainingPrice;
    data['size'] = size;
    data['color'] = color;
    data['orderId'] = orderId;
    data['date_ordered'] = dateOrdered;
    data['transaction_number'] = transactionNumber;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['return_reason'] = returnReason;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    return data;
  }
}

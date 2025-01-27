class Orderslist {
  List<Orders> ?orders;

  Orderslist({this.orders});

  Orderslist.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = new List<Orders>.empty();
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String? orderId;
  String? customer_name;
  String? status;
  String? order_date;
  String? total;

  Orders({
    this.orderId,
    this.customer_name,
    this.status,
    this.order_date,
    this.total,
  });

  Orders.fromJson(Map<dynamic, dynamic> json) {
    orderId = json['order_id'];
    customer_name = json['customer_name'];
    status = json['status'];
    order_date = json['order_date'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['customer_name'] = this.customer_name;
    data['status'] = this.status;
    data['order_date'] = this.order_date;
    data['total'] = this.total;
    return data;
  }

  // Override the toString method to get a readable format
  @override
  String toString() {
    return 'Order ID: $orderId, Customer Name: $customer_name, Status: $status, Date: $order_date, Total: $total';
  }
}


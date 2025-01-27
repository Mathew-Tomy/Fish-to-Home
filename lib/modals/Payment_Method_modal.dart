class PaymentMethod {
  List<PaymentMethods>? paymentMethods;

  PaymentMethod({this.paymentMethods});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(new PaymentMethods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paymentMethods != null) {
      data['payment_methods'] =
          this.paymentMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentMethods {
  String? photo;
  String? name;


  PaymentMethods({this.photo, this.name});

  PaymentMethods.fromJson(Map<dynamic, dynamic> json) {
    photo= json['photo'];
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['name'] = this.name;

    return data;
  }
}

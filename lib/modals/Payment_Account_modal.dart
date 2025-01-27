class PaymentAccount {
  List<PaymentAccounts>? paymentAccounts;

  PaymentAccount({this.paymentAccounts});

  PaymentAccount.fromJson(Map<String, dynamic> json) {
    if (json['payment_methods'] != null) {
      paymentAccounts = <PaymentAccounts>[];
      json['payment_methods'].forEach((v) {
        paymentAccounts!.add(new PaymentAccounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paymentAccounts != null) {
      data['payment_methods'] =
          this.paymentAccounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentAccounts {
  String? secret_key;
  String? public_key;


  PaymentAccounts({this.secret_key, this.public_key});

  PaymentAccounts.fromJson(Map<dynamic, dynamic> json) {
    secret_key= json['secret_key'];
    public_key = json['public_key'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['secret_key'] = this.secret_key;
    data['public_key'] = this.public_key;

    return data;
  }
}

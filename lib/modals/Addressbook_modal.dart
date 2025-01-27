class Addresslist {
  List<AddressData> ?addressData;

  Addresslist({this.addressData});

  Addresslist.fromJson(Map<String, dynamic> json) {
    if (json['address_data'] != null) {
      addressData = new List<AddressData>.empty();
      json['address_data'].forEach((v) {
        addressData!.add(new AddressData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressData != null) {
      data['address_data'] = this.addressData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressData {

  String ?firstname;
  String ?lastname;
  String ?customer_mobile;
  String ?customer_email;
  String ?customer_address_1;
  String ?customer_address_2;
  String ?zip;
  String ?city;
  String ?country;
  String ? state;
  String ?customer_name;
  String ?customer_short_address;




  AddressData(
      {
        this.firstname,
        this.lastname,
        this.customer_mobile,
        this.customer_email,
        this.customer_address_1,
        this.customer_address_2,
        this.zip,
        this.city,
        this.country,
        this.state,
        this.customer_name,
        this.customer_short_address,

      });

  AddressData.fromJson(Map<dynamic, dynamic> json) {

    firstname = json['first_name'];
    lastname = json['last_name'];
    customer_mobile = json['customer_mobile'];
    customer_email = json['customer_email'];
    state = json['state'];
    customer_address_1 = json['customer_address_1'];
    customer_address_2 = json['customer_address_2'];
    zip = json['zip'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    customer_name = json['customer_name'];
    customer_short_address = json['customer_short_address'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['customer_mobile'] = this.customer_mobile;
    data['customer_email'] = this.customer_email;
    data['state'] = this.state;
    data['customer_address_1'] = this.customer_address_1;
    data['customer_address_2'] = this.customer_address_2;
    data['zip'] = this.zip;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['customer_name'] = this.customer_name;
    data['customer_short_address'] = this.customer_short_address;


    return data;
  }
}

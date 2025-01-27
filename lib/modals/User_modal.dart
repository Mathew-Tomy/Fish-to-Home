class Userinfo {
  String? success;
  String? apiToken;
  Address? address; // Change from List<Address> to Address

  Userinfo({this.success, this.apiToken, this.address});

  Userinfo.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    apiToken = json['api_token'];
    // Now, 'address' is a single object, so we do not need to iterate over it.
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['api_token'] = this.apiToken;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}


class Address {
  String? customer_id; // Change the type to String as it's a string in your API response
  String? first_name;
  String? last_name;
  String? customer_email;
  String? country;
  String? state;
  String? customer_address_1;
  String? customer_address_2;
  String? zip;
  String? city;
  String? customer_mobile;
  String? customer_short_address;

  Address({
    this.customer_id,
    this.first_name,
    this.last_name,
    this.customer_email,
    this.country,
    this.state,
    this.customer_address_1,
    this.customer_address_2,
    this.zip,
    this.city,
    this.customer_mobile,
    this.customer_short_address,
  });

  Address.fromJson(Map<String, dynamic> json) {
    customer_id = json['customer_id']; // Changed to match the correct field name
    first_name = json['first_name'];
    last_name = json['last_name'];
    customer_email = json['customer_email'];
    country = json['ship_country'];
    state = json['state'];
    customer_address_1 = json['ship_address1'];
    customer_address_2 = json['ship_address2'];
    zip = json['ship_zip'];
    city = json['ship_city'];
    customer_mobile = json['customer_mobile']; // Fixed the customer_mobile field
    customer_short_address = json['customer_short_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['customer_id'] = this.customer_id;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['customer_email'] = this.customer_email;
    data['ship_country'] = this.country;
    data['state'] = this.state;
    data['ship_address1'] = this.customer_address_1;
    data['ship_address2'] = this.customer_address_2;
    data['ship_zip'] = this.zip;
    data['ship_city'] = this.city;
    data['customer_mobile'] = this.customer_mobile;
    data['customer_short_address'] = this.customer_short_address;
    return data;
  }
}







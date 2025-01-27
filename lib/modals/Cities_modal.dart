class Cities {
  String? name;
  String? secret_key;
  String? public_key;

  Cities({this.name}); // Changed 'Banner' to 'Banners' here

  Cities.fromJson(Map<String, dynamic> json) { // Changed 'Banner' to 'Banners' here
    name = json['name'];
    secret_key = json['secret_key'];
    public_key = json['public_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['secret_key'] = secret_key;
    data['public_key'] = public_key;
    return data;
  }
}

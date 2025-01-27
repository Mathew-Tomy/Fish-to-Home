class States {
  String? name;

  States({this.name}); // Changed 'Banner' to 'Banners' here

  States.fromJson(Map<String, dynamic> json) { // Changed 'Banner' to 'Banners' here
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

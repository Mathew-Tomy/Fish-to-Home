class Banners {
  String? photo;

  Banners({this.photo}); // Changed 'Banner' to 'Banners' here

  Banners.fromJson(Map<String, dynamic> json) { // Changed 'Banner' to 'Banners' here
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    return data;
  }
}

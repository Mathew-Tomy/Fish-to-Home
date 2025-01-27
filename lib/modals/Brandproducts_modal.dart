class Brandproductsmodal {
  String ?name;

  String ?photo;
  String ?same;
  String ?slug;


  Brandproductsmodal(
      {this.name,
        this.slug,
        this.photo,

        });

  Brandproductsmodal.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    photo = json['photo'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['photo'] = this.photo;


    return data;
  }
}

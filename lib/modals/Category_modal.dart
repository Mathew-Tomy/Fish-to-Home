class Categorylistmodal {
  String? photo;
  String? names;
  String? category_id;


  Categorylistmodal({this.photo, this.names,  this.category_id});

  Categorylistmodal.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    names = json['names'];
    category_id = json['category_id'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['names'] = names;
    data['category_id'] = category_id;
 
    return data;
  }
}

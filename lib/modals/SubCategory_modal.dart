class SubCategorylistmodal  {

  String? names;
  int? category_id;
  int? subcategory_id;
  String? slug;

  SubCategorylistmodal({this.names,this.slug,this.category_id,this.subcategory_id});

  SubCategorylistmodal.fromJson(Map<String, dynamic> json) {

    names = json['names'];
    category_id = json['category_id'];
    slug= json['slug'];
    subcategory_id= json['subcategory_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['names'] = names;
    data['category_id'] = category_id;
    data['slug'] = slug;
    data['subcategory_id'] = subcategory_id;
    return data;
  }
}


class Returnreason {
  List<ReturnReasons>? returnReasons;

  Returnreason({this.returnReasons});

  Returnreason.fromJson(Map<String, dynamic> json) {
    if (json['return_reasons'] != null) {
      returnReasons = <ReturnReasons>[];
      json['return_reasons'].forEach((v) {
        returnReasons!.add(new ReturnReasons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.returnReasons != null) {
      data['return_reasons'] =
          this.returnReasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReturnReasons {
  String? returnReasonId;
  String? name;

  ReturnReasons({this.returnReasonId, this.name});

  ReturnReasons.fromJson(Map<dynamic, dynamic> json) {
    returnReasonId = json['return_reason_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_reason_id'] = this.returnReasonId;
    data['name'] = this.name;
    return data;
  }
}

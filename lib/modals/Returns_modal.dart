class Returnlist {
  List<Returns>? returns;

  Returnlist({this.returns});

  Returnlist.fromJson(Map<String, dynamic> json) {
    if (json['returns'] != null) {
      returns = <Returns>[];
      json['returns'].forEach((v) {
        returns!.add(new Returns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.returns != null) {
      data['returns'] = this.returns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Returns {
  int? returnId;
  int? orderId;
  String? name;
  String? status;
  String? dateAdded;
  String? return_reason;

  Returns(
      {this.returnId,
        this.orderId,
        this.name,
        this.status,
        this.dateAdded,
        this.return_reason});

  Returns.fromJson(Map<dynamic, dynamic> json) {
    returnId = json['returnId'];
    orderId = json['orderId'];
    name = json['name'];
    status = json['status'];
    dateAdded = json['date'];
    return_reason = json['return_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['returnId'] = this.returnId;
    data['orderId'] = this.orderId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['date'] = this.dateAdded;
    data['return_reason'] = this.return_reason;
    return data;
  }
}

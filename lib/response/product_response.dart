class ProductResponse {
  String? id;
  String? name;
  String? dec;
  String? price;
  String? qty;
  String? company;
  String? category;
  List<Img>? img;

  ProductResponse(
      {this.id,
      this.name,
      this.dec,
      this.price,
      this.qty,
      this.company,
      this.category,
      this.img});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dec = json['dec'];
    price = json['price'];
    qty = json['qty'];
    company = json['company'];
    category = json['category'];
    if (json['img'] != null) {
      img = <Img>[];
      json['img'].forEach((v) {
        img!.add(new Img.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dec'] = this.dec;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['company'] = this.company;
    data['category'] = this.category;
    if (this.img != null) {
      data['img'] = this.img!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Img {
  String? url;

  Img({this.url});

  Img.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}

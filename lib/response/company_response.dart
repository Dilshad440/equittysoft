class CompanyRes {
  String? id;
  String? company;
  String? category;

  CompanyRes({id, company});

  CompanyRes.fromJson(Map<String, dynamic> json, bool isCategory) {
    id = json['id'];
    if (isCategory) {
      category = json['category'];
    }
    company = json['company'];
  }

  Map<String, dynamic> toJson(bool isCategory) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    if (isCategory) {
      data['category'] = category;
    }
    data['company'] = company;
    return data;
  }
}

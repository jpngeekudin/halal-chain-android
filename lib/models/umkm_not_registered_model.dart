class UmkmNotRegistered {
  late String id;
  late String username;
  late String companyName;
  late String createdAt;

  UmkmNotRegistered(
      {required this.id,
      required this.username,
      required this.companyName,
      required this.createdAt});

  UmkmNotRegistered.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    companyName = json['company_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['company_name'] = companyName;
    data['created_at'] = createdAt;
    return data;
  }
}

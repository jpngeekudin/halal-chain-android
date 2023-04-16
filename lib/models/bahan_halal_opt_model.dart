class BahanHalalOpts {
  late String id;
  late String name;
  late bool requireCert;

  BahanHalalOpts(this.id, this.name, this.requireCert);

  BahanHalalOpts.fromJSON(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    requireCert = json['required'];
  } 
}

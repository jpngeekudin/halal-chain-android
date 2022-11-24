class Pelaporan {
  late String image;
  late String description;
  late String umkmName;
  late String address;
  late String userName;

  Pelaporan({
    required this.image,
    required this.description,
    required this.umkmName,
    required this.address,
    required this.userName
  });

  Pelaporan.fromJSON(Map<String, dynamic> json) {
    image = json['image'];
    description = json['description'];
    umkmName = json['umkm_name'];
    address = json['address'];
    userName = json['user_name'];
  }
}
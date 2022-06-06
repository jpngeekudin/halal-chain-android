class UserData {
  late String id;
  late String username;
  late String companyName;
  late String companyAddress;
  late String companyNumber;
  late String factoryName;
  late String factoryAddress;
  late String email;
  late String productName;
  late String productType;
  late String marketingArea;
  late String marketingSystem;
  late int createdAt;

  UserData({
    required this.id,
    required this.username,
    required this.companyName,
    required this.companyAddress,
    required this.companyNumber,
    required this.factoryName,
    required this.factoryAddress,
    required this.email,
    required this.productName,
    required this.productType,
    required this.marketingArea,
    required this.marketingSystem,
    required this.createdAt
  });

  UserData.fromJSON(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    companyNumber = json['company_number'];
    factoryName = json['factory_name'];
    factoryAddress = json['factory_address'];
    email = json['email'];
    productName = json['product_name'];
    productType = json['product_type'];
    marketingArea = json['marketing_area'];
    marketingSystem = json['marketing_system'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'username': username,
      'company_name': companyName,
      'company_address': companyAddress,
      'company_number': companyNumber,
      'factory_name': factoryName,
      'factory_address': factoryAddress,
      'email': email,
      'productName': productName,
      'productType': productType,
      'marketing_area': marketingArea,
      'marketing_system': marketingSystem,
      'created_at': createdAt
    };
  }
}
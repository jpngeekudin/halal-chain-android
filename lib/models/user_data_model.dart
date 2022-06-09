class UserData {
  late String id;
  late String username;
  late String role;

  UserData({
    required this.id,
    required this.username,
    required this.role
  });

  UserData.fromJSON(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    role = json['role'];
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'username': username,
      'role': role
    };
  }
}

class UserUmkmData {
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
  late DateTime createdAt;

  UserUmkmData({
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

  UserUmkmData.fromJSON(Map<String, dynamic> json) {
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
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at']);
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
      'created_at': createdAt.millisecondsSinceEpoch
    };
  }
}

class UserAuditorData {
  late String id;
  late String noKtp;
  late String name;
  late String username;
  late String type;
  late String role;
  late String religion;
  late String address;
  late String institution;
  late String competence;
  late String experience;
  late String certCompetence;
  late String auditorExperience;
  late DateTime expiredCert;
  late DateTime createdAt;

  UserAuditorData({
    required this.id,
    required this.noKtp,
    required this.name,
    required this.username,
    required this.type,
    required this.role,
    required this.religion,
    required this.address,
    required this.institution,
    required this.competence,
    required this.experience,
    required this.certCompetence,
    required this.auditorExperience,
    required this.expiredCert,
    required this.createdAt
  });

  UserAuditorData.fromJSON(Map<String, dynamic> json) {
    id = json['_id'];
    noKtp = json['no_ktp'];
    name = json['name'];
    username = json['username'];
    type = json['type'];
    role = json['role'];
    religion = json['religion'];
    address = json['address'];
    institution = json['institution'];
    competence = json['competence'];
    experience = json['experience'];
    certCompetence = json['cert_competence'];
    auditorExperience = json['auditor_experience'];
    expiredCert = DateTime.fromMillisecondsSinceEpoch(json['expired_cert']);
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at']);
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'no_ktp': noKtp,
      'name': name,
      'username': username,
      'type': type,
      'role': role,
      'religion': religion,
      'address': address,
      'institution': institution,
      'competence': competence,
      'experience': experience,
      'cert_competence': certCompetence,
      'auditor_experience': auditorExperience,
      'expired_cert': expiredCert.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch
    };
  }
}
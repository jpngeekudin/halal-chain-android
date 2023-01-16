import 'package:halal_chain/helpers/date_helper.dart';

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
  late String? password;
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
    this.password,
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

  String createdAtString() => defaultDateFormat.format(createdAt);

  UserUmkmData.fromJSON(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    username = json['username'];
    password = json['password'];
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
      'password': password,
      'company_name': companyName,
      'company_address': companyAddress,
      'company_number': companyNumber,
      'factory_name': factoryName,
      'factory_address': factoryAddress,
      'email': email,
      'product_name': productName,
      'product_type': productType,
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
  String? password;
  late UserAuditorType type;
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
    this.password,
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

  String createdAtString() => defaultDateFormat.format(createdAt);
  String expiredCertString() => defaultDateFormat.format(expiredCert);

  UserAuditorData.fromJSON(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    noKtp = json['no_ktp'];
    name = json['name'];
    username = json['username'];
    password = json['password'];

    if (json['type'] == 'lph') type = UserAuditorType.lph;
    else if (json['type'] == 'bpjph') type = UserAuditorType.bpjph;
    else if (json['type'] == 'mui') type = UserAuditorType.mui;
    else type = UserAuditorType.lph;

    role = json['role'] ?? 'auditor';
    religion = json['religion'];
    address = json['address'];
    institution = json['institution'];
    competence = json['competence'];
    experience = json['experience'];
    certCompetence = json['cert_competence'];
    auditorExperience = json['auditor_experience'];
    expiredCert = DateTime.fromMillisecondsSinceEpoch(json['experied_cert']);
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at']);
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'no_ktp': noKtp,
      'name': name,
      'username': username,
      'password': password,
      'type': type.toString().replaceFirst('UserAuditorType.', ''),
      'role': role,
      'religion': religion,
      'address': address,
      'institution': institution,
      'competence': competence,
      'experience': experience,
      'cert_competence': certCompetence,
      'auditor_experience': auditorExperience,
      'experied_cert': expiredCert.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch
    };
  }

  String getType() {
    return type.toString().replaceFirst('UserAuditorType.', '');
  }
}

enum UserAuditorType {
  bpjph,
  lph,
  mui,
}

class UserConsumentData {
  late String id;
  late String name;
  late String username;
  late String? password;
  late String email;
  late String role;
  late String phone;
  late String address;
  late DateTime createdAt;

  UserConsumentData({
    required this.id,
    required this.name,
    required this.username,
    this.password,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    required this.createdAt
  });

  String createdAtString() => defaultDateFormat.format(createdAt);

  UserConsumentData.fromJSON(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    name = json['name'] ?? 'No Name';
    username = json['username'];
    password = json['password'];
    email = json['email'];
    role = json['role'];
    phone = json['phone'] ?? '';
    address = json['address'] ?? '';
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at']);
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'email': email,
      'role': role,
      'phone': phone,
      'address': address,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}

enum UserType {
  umkm,
  auditor,
  consument
}
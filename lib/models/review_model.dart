import 'package:halal_chain/models/user_data_model.dart';

class Review {
  late String id;
  late UserUmkmData umkm;
  late UserConsumentData consument;
  late double point;
  late String desc;
  late DateTime createdAt;
  String? transactionId;

  Review({
    required this.id,
    required this.umkm,
    required this.consument,
    required this.point,
    required this.desc,
    required this.createdAt,
    this.transactionId
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    umkm = UserUmkmData.fromJSON(json['umkm_id']);
    consument = UserConsumentData.fromJSON(json['consumen_id']);
    point = json['point'].toDouble();
    desc = json['review'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at']);
    transactionId = json['transaction_id'];
  }
}
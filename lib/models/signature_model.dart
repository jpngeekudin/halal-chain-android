class UserSignature {
  String name;
  String title;
  String sign;    // filename hasil response upload_image
  String types;   // ex: UMKM
  String typeId;  // ex: UMKM:482171681413

  UserSignature({
    required this.name,
    required this.title,
    required this.sign,
    required this.types,
    required this.typeId,
  });
}
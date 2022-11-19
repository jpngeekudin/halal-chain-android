import 'package:halal_chain/helpers/utils_helper.dart';
import 'package:logger/logger.dart';

class UmkmRegistrator {
  late String id;
  late String umkmId;
  late String username;
  late String lphId;
  late bool statusRegistration;
  late bool statusCheckByBpjph;
  late bool statusCheckByLph;
  late String statusLphCheckField;
  late bool statusCheckedMui;
  late bool certificateStatus;
  late bool fatwaStatus;

  UmkmRegistrator({
    required this.id,
    required this.username,
    required this.lphId,
    required this.statusRegistration,
    required this.statusCheckByBpjph,
    required this.statusCheckByLph,
    required this.statusLphCheckField,
    required this.statusCheckedMui,
    required this.certificateStatus,
    required this.fatwaStatus
  });

  UmkmRegistrator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    umkmId = json['umkm_id'];
    username = json['username'];
    lphId = json['lph_id'];
    statusRegistration = json['status_registration'];
    statusCheckByBpjph = json['status_check_by_BPJPH'];
    statusCheckByLph = json['status_check_by_lph'];
    statusLphCheckField = json['status_LPH_check_field'];
    statusCheckedMui = json['status_checked_MUI'];
    certificateStatus = json['Certificate_status'];
    fatwaStatus = ![null, false].contains(json['status_fatwa']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'umkm_id': umkmId,
      'username': username,
      'lph_id': lphId,
      'status_registration': statusRegistration,
      'status_check_by_BPJPH': statusCheckByBpjph,
      'status_check_by_lph': statusCheckByLph,
      'status_LPH_check_field': statusLphCheckField,
      'status_checked_MUI': statusCheckedMui,
      'Certificate_status': certificateStatus
    };
  }
}
class UmkmRegistrator {
  late String id;
  late String username;
  late bool statusRegistration;
  late bool statusCheckByBpjph;
  late bool statusLphCheckField;
  late bool statusCheckedMui;
  late bool certificateStatus;

  UmkmRegistrator({
    required this.id,
    required this.username,
    required this.statusRegistration,
    required this.statusCheckByBpjph,
    required this.statusLphCheckField,
    required this.statusCheckedMui,
    required this.certificateStatus
  });

  UmkmRegistrator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    statusRegistration = json['status_registration'];
    statusCheckByBpjph = json['status_check_by_BPJPH'];
    statusLphCheckField = json['status_LPH_check_field'];
    statusCheckedMui = json['status_checked_MUI'];
    certificateStatus = json['Certificate_status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'status_registration': statusRegistration,
      'status_check_by_BPJPH': statusCheckByBpjph,
      'status_LPH_check_field': statusLphCheckField,
      'status_checked_MUI': statusCheckedMui,
      'Certificate_status': certificateStatus
    };
  }
}
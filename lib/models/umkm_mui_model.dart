class UmkmMuiData {
  late String id;
  late bool statusRegistration;
  late bool statusCheckByBpjph;
  late String descCheckByBpjph;
  late String descResult;
  late UmkmMuiLphAppointment lphAppointment;
  late String lphCheckingDataStatus;
  late String lphCheckingDataDesc;
  late bool statusLphCheckField;
  late String lphReviewStatus;
  late String lphToMui;
  late bool statusCheckedMui;
  late String muiDecisionResult;
  late bool certificateStatus;
  late String certificateData;
  late String qrData;
  late String muiStatus;

  UmkmMuiData({
    required this.id,
    required this.statusRegistration,
    required this.statusCheckByBpjph,
    required this.descCheckByBpjph,
    required this.descResult,
    required this.lphAppointment,
    required this.lphCheckingDataStatus,
    required this.lphCheckingDataDesc,
    required this.statusLphCheckField,
    required this.lphReviewStatus,
    required this.lphToMui,
    required this.statusCheckedMui,
    required this.muiDecisionResult,
    required this.certificateStatus,
    required this.certificateData,
    required this.qrData,
    required this.muiStatus,
  });

  UmkmMuiData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    statusRegistration = json['status_registration'];
    statusCheckByBpjph = json['status_check_by_BPJPH'];
    descCheckByBpjph = json['desc_check_by_BPJPH'];
    descResult = json['desc_result'];
    lphAppointment = UmkmMuiLphAppointment.fromJson(json['LPH_appointment']);
    lphCheckingDataStatus = json['LPH_Checking_data_status'];
    lphCheckingDataDesc = json['LPH_Checking_data_desc'];
    statusLphCheckField = json['status_LPH_check_field'];
    lphReviewStatus = json['LPH_review_status'];
    lphToMui = json['LPH_to_MUI'];
    statusCheckedMui = json['status_checked_MUI'];
    muiDecisionResult = json['MUI_decicion_result'];
    certificateStatus = json['Certificate_status'];
    certificateData = json['Certificate_data'];
    qrData = json['QR_data'];
    muiStatus = json['MUI_status'];
  }
}

class UmkmMuiLphAppointment {
  late String bpjphId;
  late String lphId;

  UmkmMuiLphAppointment({
    required this.bpjphId,
    required this.lphId
  });

  UmkmMuiLphAppointment.fromJson(Map<String, dynamic> json) {
    bpjphId = json['BPJPH_id'];
    lphId = json['LPH_id'];
  }

  Map<String, String> toJson() {
    return {
      'BPJPH_id': bpjphId,
      'LPH_id': lphId,
    };
  }
}
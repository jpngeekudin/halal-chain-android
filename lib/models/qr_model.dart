import 'package:halal_chain/helpers/utils_helper.dart';
import 'package:halal_chain/models/user_data_model.dart';

class QrDetail {
  late UserUmkmData profile;
  late QrDetailCore core;

  QrDetail(this.profile, this.core);

  QrDetail.fromJson(Map<String, dynamic> json) {
    profile = UserUmkmData.fromJSON(json['profile']);
    core = QrDetailCore(
      id: json['core']['_id'],
      prevId: json['core']['prev_id'],
      umkmId: json['core']['umkm_id'],
      registration: QrDetailCoreRegistration(
        json['core']['registration']['status'],
        json['core']['registration']['date']
      ),
      bpjphChecked: QrDetailCoreBpjphChecked(
        json['core']['bpjph_checked']['status'],
        json['core']['bpjph_checked']['desc'],
        json['core']['bpjph_checked']['result'],
        json['core']['bpjph_checked']['date'],
      ),
      lphAppointment: QrDetailCoreLphAppointment(
        json['core']['lph_appointment']['bpjph_id'],
        json['core']['lph_appointment']['lph_id'],
        json['core']['lph_appointment']['date'],
      ),
      lphChecked: QrDetailCoreLphChecked(
        toBool(json['core']['lph_checked']['status']),
        json['core']['lph_checked']['desc'],
        json['core']['lph_checked']['survey_location'],
        toBool(json['core']['lph_checked']['review_status']),
        toBool(json['core']['lph_checked']['to_mui']),
        json['core']['lph_checked']['date'],
      ),
      mui: QrDetailCoreMui(
        json['core']['mui']['checked_status'],
        json['core']['mui']['decision_desc'],
        json['core']['mui']['approved'],
        json['core']['mui']['date'],
      ),
      certificate: QrDetailCoreCertificate(
        json['core']['certificate']['data'],
        json['core']['certificate']['status'],
        json['core']['certificate']['created_date'],
        json['core']['certificate']['expired_date'],
      ),
      qrData: json['core']['QR_data']
    );
  }
}

// QR DETAIL CORE

class QrDetailCore {
  late String id;
  late String prevId;
  late String umkmId;
  late QrDetailCoreRegistration registration;
  late QrDetailCoreBpjphChecked bpjphChecked;
  late QrDetailCoreLphAppointment lphAppointment;
  late QrDetailCoreLphChecked lphChecked;
  late QrDetailCoreMui mui;
  late QrDetailCoreCertificate certificate;
  late String qrData;

  QrDetailCore({
    required this.id,
    required this.prevId,
    required this.umkmId,
    required this.registration,
    required this.bpjphChecked,
    required this.lphAppointment,
    required this.lphChecked,
    required this.mui,
    required this.certificate,
    required this.qrData,
  });

  QrDetailCore.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    prevId = json['prev_id'];
    umkmId = json['umkm_id'];
    registration = QrDetailCoreRegistration(
      json['registration']['status'],
      json['registration']['date']
    );
    bpjphChecked = QrDetailCoreBpjphChecked(
      json['bpjph_checked']['status'],
      json['bpjph_checked']['desc'],
      json['bpjph_checked']['result'],
      json['bpjph_checked']['date'],
    );
    lphAppointment = QrDetailCoreLphAppointment(
      json['lph_appointment']['bpjph_id'],
      json['lph_appointment']['lph_id'],
      json['lph_appointment']['date'],
    );
    lphChecked = QrDetailCoreLphChecked(
      toBool(json['lph_checked']['status']),
      json['lph_checked']['desc'],
      json['lph_checked']['survey_location'],
      toBool(json['lph_checked']['review_status']),
      toBool(json['lph_checked']['to_mui']),
      json['lph_checked']['date'],
    );
    mui = QrDetailCoreMui(
      json['mui']['checked_status'],
      json['mui']['decision_desc'],
      json['mui']['approved'],
      json['mui']['date'],
    );
    certificate = QrDetailCoreCertificate(
      json['certificate']['data'],
      json['certificate']['status'],
      json['certificate']['created_date'],
      json['certificate']['expired_date'],
    );
    qrData = json['QR_data'];
  }
}

class QrDetailCoreRegistration {
  bool status;
  late DateTime date;

  QrDetailCoreRegistration(this.status, int timestamp) {
    date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}

class QrDetailCoreBpjphChecked {
  bool status;
  String desc;
  String result;
  late DateTime date;

  QrDetailCoreBpjphChecked(this.status, this.desc, this.result, int timestamp) {
    date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}

class QrDetailCoreLphAppointment {
  String bpjphId;
  String lphId;
  late DateTime date;

  QrDetailCoreLphAppointment(this.bpjphId, this.lphId, int timestamp) {
    date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}

class QrDetailCoreLphChecked {
  bool status;
  String desc;
  bool surveyLocation;
  bool reviewStatus;
  bool toMui;
  late DateTime date;

  QrDetailCoreLphChecked(
    this.status,
    this.desc,
    this.surveyLocation,
    this.reviewStatus,
    this.toMui,
    int timestamp
  ) {
    date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}

class QrDetailCoreMui {
  bool checkedStatus;
  String decisionDesc;
  String approved;
  late DateTime date;

  QrDetailCoreMui(
    this.checkedStatus,
    this.decisionDesc,
    this.approved,
    int timestamp
  ) {
    date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}

class QrDetailCoreCertificate {
  String data;
  bool status;
  late DateTime createdDate;
  late DateTime expiredDate;

  QrDetailCoreCertificate(
    this.data,
    this.status,
    int createdTimestamp,
    int expiredTimestamp,
  ) {
    createdDate = DateTime.fromMillisecondsSinceEpoch(createdTimestamp);
    expiredDate = DateTime.fromMillisecondsSinceEpoch(expiredTimestamp);
  }
}
const apiPrefix = 'http://103.176.79.228:5000';

abstract class ApiList {
  static String login = '$apiPrefix/auth/login';
  static String registerUmkm = '$apiPrefix/auth/register_umkm';
  static String registerAuditor = '$apiPrefix/auth/register_auditor';
  static String registerConsument = '$apiPrefix/auth/register_consumen';
  static String updateUserUmkm = '$apiPrefix/account/update_umkm';
  static String updateUserAuditor = '$apiPrefix/account/update_auditor';
  static String updateUserConsument = '$apiPrefix/account/update_consumen';
  static String getUserUmkm = '$apiPrefix/account/get_umkm';
  static String getUserAuditor = '$apiPrefix/account/get_auditor';
  static String getUserConsument = '$apiPrefix/account/get_consumen';

  static String umkmCreateInit = '$apiPrefix/umkm/create_init';
  static String umkmCreateDetail = '$apiPrefix/umkm/insert_detail_umkm';
  static String umkmCreatePenetapanTim = '$apiPrefix/umkm/insert_penetapan_tim';
  static String umkmCreateBuktiPelaksanaan = '$apiPrefix/umkm/insert_bukti_pelaksanaan';
  static String umkmGetEvaluasiSoal = '$apiPrefix/umkm/get_soal_evaluasi';
  static String umkmCreateEvaluasiJawaban = '$apiPrefix/umkm/input_jawaban';
  static String umkmGetAuditSoal = '$apiPrefix/umkm/get_audit_internal';
  static String umkmCreateAuditJawaban = '$apiPrefix/umkm/jawab_audit_internal';
}
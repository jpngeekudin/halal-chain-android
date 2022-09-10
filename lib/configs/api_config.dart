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
  static String umkmGetDocument = '$apiPrefix/umkm/get_ukmk_detail';
  static String umkmCreateDetail = '$apiPrefix/umkm/insert_detail_umkm';
  static String umkmCreatePenetapanTim = '$apiPrefix/umkm/insert_penetapan_tim';
  static String umkmCreateBuktiPelaksanaan = '$apiPrefix/umkm/insert_bukti_pelaksanaan';
  static String umkmGetEvaluasiSoal = '$apiPrefix/umkm/get_soal_evaluasi';
  static String umkmCreateEvaluasiJawaban = '$apiPrefix/umkm/input_jawaban';
  static String umkmGetAuditSoal = '$apiPrefix/umkm/get_audit_internal';
  static String umkmCreateAuditJawaban = '$apiPrefix/umkm/jawaban_audit_internal';
  static String umkmCreateDaftarHadirKaji = '$apiPrefix/umkm/daftar_hadir_kaji';
  static String umkmCreateFormPembelianPemeriksaan = '$apiPrefix/umkm/form_pembelian_pemeriksaan';
  static String umkmCreateFormPembelianPemeriksaanImport = '$apiPrefix/umkm/form_pembelian_pemeriksaan_import';
  static String umkmCreateFormStokBarang = '$apiPrefix/umkm/form_stok_barang';
  static String umkmCreateFormProduksi = '$apiPrefix/umkm/form_produksi';
  static String umkmCreateFormPemusnahan = '$apiPrefix/umkm/form_pemusnahan';
  static String umkmFormKebersihan = '$apiPrefix/umkm/form_pengecekan_kebersihan';
  static String umkmBarangHalal = '$apiPrefix/umkm/daftar_barang_halal';
  static String umkmMatriksProduk = '$apiPrefix/umkm/matriks_produk';

  static String imageUpload = '$apiPrefix/util/upload_files';
  static String utilLoadFile = '$apiPrefix/util/load_image';

  static String simulasiGetBahan = '$apiPrefix/simulasi/get_bahan';
  static String simulasiInputBahan = '$apiPrefix/simulasi/input_bahan';
  static String simulasiUpdateBahan = '$apiPrefix/simulasi/update_bahan';
  static String simulasiSJH = '$apiPrefix/simulasi/simulasi_sjh';

  static String coreRegistrationSjh = '$apiPrefix/core/registration_sjh';
  static String coreGetUmkmRegistered = '$apiPrefix/core/get_umkm_registered';
  static String coreGetUmkmRegistrationData = '$apiPrefix/core/umkm_registration_data';
  static String coreBpjphCheckingData = '$apiPrefix/core/BPJPH_checking_data';
  static String coreGetLph = '$apiPrefix/core/get_LPH';
  static String coreLphAppointment = '$apiPrefix/core/LPH_appointment';
  static String coreLphCheckingData = '$apiPrefix/core/LPH_Checking_data';
  static String coreReviewBussinessPlace = '$apiPrefix/core/review_bussiness_place';
  static String coreMuiGetData = '$apiPrefix/core/mui_get_data';
  static String coreMuiCheckingData = '$apiPrefix/core/mui_checking_data';
  static String coreBpjphInsertCert = '$apiPrefix/core/bpjph_insert_certificate_data';
  static String coreQrDetail = '$apiPrefix/core/qr_detail';
}
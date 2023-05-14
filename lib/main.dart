import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_appoint_lph_page.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_check_sjh_mui_page.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_check_sjh_page.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_pelaporan_page.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_registrator_list_page.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_review_page.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_review_user_page.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_unregistered_umkm_page.dart';
import 'package:halal_chain/pages/auditor_pages/auditor_upload_cert_page.dart';
import 'package:halal_chain/pages/consument_pages/consument_pelaporan_page.dart';
import 'package:halal_chain/pages/consument_pages/consument_qr_detail_page.dart';
import 'package:halal_chain/pages/consument_pages/consument_scan_page.dart';
import 'package:halal_chain/pages/home_page.dart';
import 'package:halal_chain/pages/login_page.dart';
import 'package:halal_chain/pages/profile_detail_page.dart';
import 'package:halal_chain/pages/profile_page.dart';
import 'package:halal_chain/pages/register_auditor_page.dart';
import 'package:halal_chain/pages/register_consumen_page.dart';
import 'package:halal_chain/pages/register_page.dart';
import 'package:halal_chain/pages/register_umkm_page.dart';
import 'package:halal_chain/pages/splash_screen_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_audit_internal_2_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_audit_internal_list_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_bahan_halal_list_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_bahan_halal_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_daftar_hadir_kaji_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_detail_insert_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_evaluasi_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_kebersihan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_matriks_list_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_matriks_produk_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_pembelian_list_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_pembelian_pemeriksaan_bahan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_pemusnahan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_penilaian_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_produksi_list_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_produksi_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_stok_barang_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_data_sjh_pages/umkm_team_assign_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_qr_view_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_registrasi_sjh_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_simulasi_2_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_bahan_halal_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_daftar_hadir_kaji_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_detail_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_evaluasi_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_kebersihan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_matriks_produk_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_pembelian_bahan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_pemusnahan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_penetapan_tim_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_penilaian_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_produksi_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_view_sjh_pages/umkm_view_stok_barang_page.dart';
import 'package:logger/logger.dart';

// class DownloadClass {
//   static void callback(String id, DownloadTaskStatus status, int progress) {
//     final logger = Logger();
//     logger.i('$id - $status - $progress%');
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(ignoreSsl: true);
  // FlutterDownloader.registerCallback(DownloadClass.callback);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData _theme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      textTheme: GoogleFonts.robotoTextTheme(
        Theme.of(context).textTheme
      )
    );
  }

  Future<bool> _isLoggedIn() async {
    final storage = FlutterSecureStorage();
    final userDataStr = await storage.read(key: 'user');
    if (userDataStr != null) return true;
    else return false; 
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _theme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth/login',
      routes: {
        '/': (context) => SplashScreenPage(),
        '/home': (context) => HomePage(),

        '/auth/login': (context) => LoginPage(),
        '/auth/register': (context) => RegisterPage(),
        '/auth/register/umkm': (context) => RegisterUmkmPage(),
        '/auth/register/auditor': (context) => RegisterAuditorPage(),
        '/auth/register/consument': (context) => RegisterConsumenPage(),

        '/profile': (context) => ProfilePage(),
        '/profile/detail': (context) => ProfileDetailPage(),
        // '/profile/edit/umkm': (context) => ProfileEditUmkmPage(),
        // '/profile/edit/auditor': (context) => ProfileEditAuditorPage(),
        // '/profile/edit/consument': (context) => ProfileEditConsumentPage(),

        '/umkm/data-sjh': (context) => UmkmDataSjhPage(),
        '/umkm/data-sjh/detail-umkm': (context) => UmkmDetailInsertPage(),
        '/umkm/data-sjh/penetapan-tim': (context) => UmkmTeamAssignPage(),
        '/umkm/data-sjh/bukti-pelaksanaan': (context) => UmkmPenilaianPage(),
        '/umkm/data-sjh/evaluasi': (context) => UmkmEvaluasiPage(),
        // '/umkm/data-sjh/audit-internal': (context) => UmkmAuditInternal2Page(),
        '/umkm/data-sjh/audit-internal': (context) => UmkmAuditInternalListPage(),
        '/umkm/data-sjh/audit-internal/create': (context) => UmkmAuditInternal2Page(),
        '/umkm/data-sjh/daftar-hadir-kajian': (context) => UmkmDaftarHadirKajiPage(),
        '/umkm/data-sjh/pembelian-bahan': (context) => UmkmPembelianListPage(),
        '/umkm/data-sjh/pembelian-bahan/create': (context) => UmkmPembelianPemerikasaanBahanPage(),
        '/umkm/data-sjh/pembelian-bahan-import': (context) => UmkmPembelianListPage(typeBahan: 'import'),
        '/umkm/data-sjh/pembelian-bahan-import/create': (context) => UmkmPembelianPemerikasaanBahanPage(typeBahan: 'import'),
        '/umkm/data-sjh/stok-bahan': (context) => UmkmStokBarangPage(),
        '/umkm/data-sjh/produksi': (context) => UmkmProduksiListPage(),
        '/umkm/data-sjh/produksi/create': (context) => UmkmProduksiPage(),
        '/umkm/data-sjh/pemusnahan': (context) => UmkmPemusnahanPage(),
        '/umkm/data-sjh/kebersihan': (context) => UmkmKebersihanPage(),
        '/umkm/data-sjh/bahan-halal': (context) => UmkmBahanHalalListPage(),
        '/umkm/data-sjh/bahan-halal/create': (context) => UmkmBahanHalalPage(),
        '/umkm/data-sjh/matriks': (context) => UmkmMatriksListPage(),
        '/umkm/data-sjh/matriks/create': (context) => UmkmMatriksProdukPage(),

        '/umkm/view-sjh/detail-umkm': (context) => UmkmViewDetailPage(),
        '/umkm/view-sjh/penetapan-tim': (context) => UmkmViewPenetapanTimPage(),
        '/umkm/view-sjh/bukti-pelaksanaan': (context) => UmkmViewPenilaianPage(),
        '/umkm/view-sjh/evaluasi': (context) => UmkmViewEvaluasiPage(),
        '/umkm/view-sjh/daftar-hadir-kajian': (context) => UmkmViewDaftarHadirKajiPage(),
        '/umkm/view-sjh/pembelian-bahan': (context) => UmkmViewPembelianBahanPage(bahanType: 'non-import'),
        '/umkm/view-sjh/pembelian-bahan-import': (context) => UmkmViewPembelianBahanPage(bahanType: 'import'),
        '/umkm/view-sjh/stok-bahan': (context) => UmkmViewStokBarangPage(),
        '/umkm/view-sjh/produksi': (context) => UmkmViewProduksiPage(),
        '/umkm/view-sjh/pemusnahan': (context) => UmkmViewPemusnahanPage(),
        '/umkm/view-sjh/kebersihan': (context) => UmkmViewKebersihanPage(),
        '/umkm/view-sjh/bahan-halal': (context) => UmkmViewBahanHalalPage(),
        '/umkm/view-sjh/matriks': (context) => UmkmViewMatriksProdukPage(),

        '/umkm/simulasi': (context) => UmkmSimulasi2Page(),
        '/umkm/registrasi-sjh': (context) => UmkmRegistrasiSjhPage(),
        '/umkm/qr-view': (context) => UmkmQrViewPage(),

        '/auditor/daftar-sjh': (context) => AuditorRegistratorListPage(),
        '/auditor/daftar-not-registered': (context) => AuditorUnregisteredUmkmPage(),
        '/auditor/check-sjh': (context) => AuditorCheckSjhPage(),
        '/auditor/check-sjh/audit-internal': (context) => UmkmAuditInternalListPage(enableCreate: false,),
        '/auditor/check-sjh/bahan-halal': (context) => UmkmBahanHalalListPage(enableCreate: false),
        '/auditor/check-sjh/matriks': (context) => UmkmMatriksListPage(enableCreate: false,),
        '/auditor/check-sjh/pembelian-bahan': (context) => UmkmPembelianListPage(enableCreate: false,),
        '/auditor/check-sjh/pembelian-bahan-import': (context) => UmkmPembelianListPage(typeBahan: 'import', enableCreate: false,),
        '/auditor/check-sjh/produksi': (context) => UmkmProduksiListPage(enableCreate: false,),
        '/auditor/check-sjh-mui': (context) => AuditorCheckSjhMuiPage(),
        '/auditor/appoint-lph': (context) => AuditorAppointLphPage(),
        '/auditor/upload-cert': (context) => AuditorUploadCertPage(),
        '/auditor/upload-fatwa': (context) => AuditorUploadCertPage(type: 'mui'),
        '/auditor/review': (context) => AuditorReviewUserPage(),
        '/auditor/review/list': (context) => AuditorReviewPage(),
        '/auditor/pelaporan': (context) => AuditorPelaporanPage(),

        '/consument/scan': (context) => ConsumentScanPage(),
        '/consument/qr-detail': (context) => ConsumentQrDetailPage(),
        '/consument/pelaporan': (context) => ConsumentPelaporanPage(),
      },
      // home: FutureBuilder(
      //   future: _isLoggedIn(),
      //   builder: (context, AsyncSnapshot snapshot) {
      //     if (snapshot.hasData && snapshot.data) return HomePage();
      //     else if (snapshot.hasData && !snapshot.data) return LoginPage();
      //     else return SplashScreenPage();
      //   },
      // )
    );
  }
}
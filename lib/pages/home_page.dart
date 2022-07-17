import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/avatar_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/pages/profile_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_audit_internal_2_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_audit_internal_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_bahan_halal_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_daftar_hadir_kaji_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_detail_insert_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_evaluasi_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_kebersihan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_matriks_produk_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_pembelian_pemeriksaan_bahan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_pemusnahan_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_penilaian_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_produksi_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_simulasi_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_stok_barang_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_team_assign_page.dart';
import 'package:halal_chain/services/core_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _getMenuItem({
    required String title,
    required String subtitle,
    bool isDone = false,
    required BuildContext context,
    Route? route,
  }) {
    return  InkWell(
      onTap: () {
        if (route != null) {
          Navigator.of(context).push(route).then((value) {
            setState(() { });
          });
        }
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDone
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : Colors.grey[400]!.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: isDone 
              ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
              : Icon(Icons.watch_later_outlined, color: Colors.grey[800]),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                )),
                Text(subtitle, style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12
                ),)
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 48, color: Theme.of(context).primaryColor)
        ],
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProfilePage())
    );
  }

  Future<Map<String, dynamic>?> _getUserData(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final userDataStr = await storage.read(key: 'user');
    if (userDataStr == null) {
      return { 'username': 'N/A' };
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
    }

    else {
      final userData = jsonDecode(userDataStr);
      return userData;
    }
  }

  Future _createInit() async {
    final core = CoreService();
    final userData = await getUserData();
    final response = await core.createInit(userData!.id);
    return response.data;
  }

  Future<UmkmDocument?> _getUmkmDocument() async {
    try {
      final core = CoreService();
      final userData = await getUserData();
      final response = await core.genericGet(ApiList.umkmGetDocument, { 'creator_id': userData!.id });

      if (response.data != null) {
        final umkmDocument = UmkmDocument.fromJSON(response.data);
        setUmkmDocument(umkmDocument);
        return umkmDocument;
      }

      else {
        final createInitResponse = await _createInit();
        return await _getUmkmDocument();
      }
    }

    catch(err, stacktrace) {
      print(stacktrace);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: FutureBuilder(
              future: _getUserData(context),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final userData = UserData.fromJSON(snapshot.data);
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text('Hello, ${userData.username}!', style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                            InkWell(
                              onTap: () => _navigateToProfile(context),
                              child: CircleAvatar(
                                radius: 18,
                                // backgroundColor: Theme.of(context).primaryColor,
                                backgroundImage: NetworkImage(getAvatarUrl(userData.username))
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: AssetImage('assets/images/home_hero.jpg'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken
                            )
                          )
                        ),
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 30),
                        height: 200,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text('Pastikan makanan yang anda makan halal.', style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),),
                            ),
                          ],
                        ),
                      ),

                      if (userData.role == 'umkm') 
                        FutureBuilder(
                          future: _getUmkmDocument(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              final UmkmDocument document = snapshot.data;
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Create Init',
                                      subtitle: 'Initializing a docs',
                                      isDone: true,
                                      context: context,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Detail UMKM',
                                      subtitle: 'Inserting UMKM Details',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmDetailInsertPage()),
                                      isDone: document.detailUmkm,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Penetapan Tim',
                                      subtitle: 'Menetapkan orang-orang yang bekerja di tim',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmTeamAssignPage()),
                                      isDone: document.penetapanTim,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Bukti Pelaksanaan',
                                      subtitle: 'Memasukkan bukti pelaksanaan',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmPenilaianPage()),
                                      isDone: document.buktiPelaksanaan,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Evaluasi',
                                      subtitle: 'Quiz Test Evaluasi',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmEvaluasiPage()),
                                      isDone: document.jawabanEvaluasi,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Audit Internal',
                                      subtitle: 'Audit Internal',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmAuditInternal2Page()),
                                      isDone: document.jawabanAudit
                                    ),
                                  ), 
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Daftar Hadir Kajian',
                                      subtitle: 'Mengisi daftar hadir kajian',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmDaftarHadirKajiPage()),
                                      isDone: document.daftarHasilKaji,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Pembelian dan Pemeriksaan Bahan',
                                      subtitle: 'Mengisi daftar pembelian dan pemeriksaan bahan',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmPembelianPemerikasaanBahanPage()),
                                      isDone: document.pembelian,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Pembelian dan Pemeriksaan Bahan Import',
                                      subtitle: 'Mengisi daftar pembelian dan pemeriksaan bahan import',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmPembelianPemerikasaanBahanPage(typeBahan: 'import')),
                                      isDone: document.pembelianImport
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Stok Bahan',
                                      subtitle: 'Mengisi form stok bahan',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmStokBarangPage()),
                                      isDone: document.stokBarang,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Produksi',
                                      subtitle: 'Mengisi form produksi',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmProduksiPage()),
                                      isDone: document.formProduksi,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Pemusnahan Barang / Produk',
                                      subtitle: 'Mengisi form pemusnahan barang / produk',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmPemusnahanPage()),
                                      isDone: document.formPemusnahan,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Pengecekan Kebersihan',
                                      subtitle: 'Mengisi form pengecekan kebersihan fasilitas produksi dan kendaraan',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmKebersihanPage()),
                                      isDone: document.formPengecekanKebersihan,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Bahan Halal',
                                      subtitle: 'Mengisi form daftar bahan halal',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmBahanHalalPage()),
                                      isDone: document.daftarBahanHalal,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Matriks Produk',
                                      subtitle: 'Mengisi form matriks produk',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmMatriksProdukPage()),
                                      isDone: document.matriksProduk,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: _getMenuItem(
                                      title: 'Simulasi SJH',
                                      subtitle: 'Mengisi form simulasi SJH',
                                      context: context,
                                      route: MaterialPageRoute(builder: (context) => UmkmSimulasiPage()),
                                      isDone: false
                                    ),
                                  )
                                ],
                              );
                            }

                            else {
                              print(snapshot.error);
                              return Container(
                                height: 400,
                                alignment: Alignment.center,
                                child: snapshot.hasError
                                  ? Text('Terjadi kesalahan', style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                  ))
                                  : CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        
                      if (userData.role != 'umkm')
                        ...[Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: _getMenuItem(
                            title: 'Data SJH',
                            subtitle: 'Kelola data SJH',
                            context: context
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: _getMenuItem(
                            title: 'Simulasi SJH',
                            subtitle: 'Simulasikan data SJH yang sudah di masukkan',
                            context: context
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: _getMenuItem(
                            title: 'Daftar Sertifikat',
                            subtitle: 'Daftarkan SJH untuk mendapatkan sertifikasi',
                            context: context
                          ),
                        )],
                    ],
                  );
                }

                else {
                  return Container(
                    height: 400,
                    alignment: Alignment.center,
                    child: Text('You are not logged in'),
                  );
                }
              }
            ),
          ),
        )
      ),
    );
  }
}
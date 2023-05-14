import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/avatar_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/home_item_widget.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _enableSimulasiSJH = false;

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed('/profile');
  }

  Future<Map<String, dynamic>?> _getUserData(BuildContext context) async {
    try {
      final storage = FlutterSecureStorage();
      final userDataStr = await storage.read(key: 'user');
      if (userDataStr == null) {
        return {'username': 'N/A'};
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        // );
      } else {
        final userData = jsonDecode(userDataStr);
        return userData;
      }
    } catch (err, trace) {
      final logger = Logger();
      logger.e(trace);
    }
  }

  Future _createInit() async {
    final core = CoreService();
    final userData = await getUserData();
    final response = await core.createInit(userData!.id);
    return response.data;
  }

  Future<UmkmDocument?> _getUmkmDocument() async {
    final logger = Logger();
    try {
      // final currentDocument = await getUmkmDocument();
      // if (currentDocument != null) return currentDocument;

      final core = CoreService();
      final userData = await getUserData();
      final response = await core
          .genericGet(ApiList.umkmGetDocument, {'creator_id': userData!.id});

      if (response.data != null) {
        final umkmDocument = UmkmDocument.fromJSON(response.data);
        setUmkmDocument(umkmDocument);
        _enableSimulasiSJH = umkmDocument.allFilled();
        return umkmDocument;
      } else {
        final createInitResponse = await _createInit();
        return await _getUmkmDocument();
      }
    } catch (err, stacktrace) {
      print(stacktrace);
      if (err is DioError &&
          err.response?.data['data'].toLowerCase() == 'not found') {
        final createInitResponse = await _createInit();
        return await _getUmkmDocument();
      } else {
        rethrow;
      }
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
                              child: Text(
                                'Hello, ${userData.username}!',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () => _navigateToProfile(context),
                              child: CircleAvatar(
                                  radius: 18,
                                  // backgroundColor: Theme.of(context).primaryColor,
                                  backgroundImage: NetworkImage(
                                      getAvatarUrl(userData.username))),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/home_hero.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken))),
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
                              child: Text(
                                'Pastikan makanan yang anda makan halal.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
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
                                    child: HomeItemWidget(
                                      title: 'Data SJH',
                                      subtitle: 'Input data SJH',
                                      isDone: true,
                                      route: '/umkm/data-sjh',
                                    ),
                                  ),
                                  if (_enableSimulasiSJH)
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: HomeItemWidget(
                                          title: 'Simulasi SJH',
                                          subtitle: 'Mengisi form simulasi SJH',
                                          route: '/umkm/simulasi',
                                          isDone: false),
                                    ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: HomeItemWidget(
                                      title: 'Registrasi SJH',
                                      subtitle: 'Mendaftar SJH',
                                      isDone: true,
                                      route: '/umkm/registrasi-sjh',
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: HomeItemWidget(
                                      title: 'Lihat QR',
                                      subtitle:
                                          'Lihat QR dari sertifikat yang sudah dibuat',
                                      isDone: true,
                                      route: '/umkm/qr-view',
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                height: 400,
                                alignment: Alignment.center,
                                child: snapshot.hasError
                                    ? Text('Terjadi kesalahan',
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold))
                                    : CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      if (userData.role == 'auditor') ...[
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: HomeItemWidget(
                            title: 'Check UMKM',
                            subtitle:
                                'Checking data UMKM yang sudah daftar SJH',
                            isDone: true,
                            route: '/auditor/daftar-sjh',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: HomeItemWidget(
                            title: 'Check Unregistered UMKM',
                            subtitle:
                                'List of UMKM that already have completed SJH Data and Simulation but still not registered',
                            isDone: true,
                            route: '/auditor/daftar-not-registered',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: HomeItemWidget(
                            title: 'Review',
                            subtitle: 'See UMKM Review by Consument',
                            isDone: true,
                            route: '/auditor/review',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: HomeItemWidget(
                            title: 'Pelaporan',
                            subtitle: 'See Pelaporan List',
                            isDone: true,
                            route: '/auditor/pelaporan',
                          ),
                        ),
                      ],
                      if (userData.role != 'umkm') ...[
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 20),
                        //   child: HomeItemWidget(
                        //     title: 'Data SJH',
                        //     subtitle: 'Kelola data SJH',
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 20),
                        //   child: HomeItemWidget(
                        //     title: 'Simulasi SJH',
                        //     subtitle: 'Simulasikan data SJH yang sudah di masukkan',
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 20),
                        //   child: HomeItemWidget(
                        //     title: 'Daftar Sertifikat',
                        //     subtitle: 'Daftarkan SJH untuk mendapatkan sertifikasi',
                        //   ),
                        // )
                      ],
                      if (userData.role == 'consumen') ...[
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: HomeItemWidget(
                            title: 'Pelaporan',
                            subtitle: 'Report a product',
                            isDone: true,
                            route: '/consument/pelaporan',
                          ),
                        )
                      ],
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: HomeItemWidget(
                          title: 'Scan QR',
                          subtitle: 'Scan QR for checking halal certificate',
                          isDone: true,
                          route: '/consument/scan',
                        ),
                      )
                    ],
                  );
                } else {
                  return Container(
                    height: 400,
                    alignment: Alignment.center,
                    child: Text('You are not logged in'),
                  );
                }
              }),
        ),
      )),
    );
  }
}

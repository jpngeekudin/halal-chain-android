import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/helpers/avatar_helper.dart';
import 'package:halal_chain/pages/profile_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_detail_insert_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_penilaian_page.dart';
import 'package:halal_chain/pages/umkm_pages/umkm_team_assign_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  Widget _getMenuItem({
    required String title,
    required String subtitle,
    required BuildContext context,
    Route? route,
  }) {
    return  InkWell(
      onTap: () => {
        if (route != null) Navigator.of(context).push(route)
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 60,
            height: 60,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: FutureBuilder(
                    future: _getUserData(context),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text('Hello, ${snapshot.data['username']}!', style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                            InkWell(
                              onTap: () => _navigateToProfile(context),
                              child: CircleAvatar(
                                radius: 18,
                                // backgroundColor: Theme.of(context).primaryColor,
                                backgroundImage: NetworkImage(getAvatarUrl(snapshot.data['username']))
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor,
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

                // SJH MENU
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: _getMenuItem(
                    title: 'Create Init',
                    subtitle: 'Initializing a docs',
                    context: context
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: _getMenuItem(
                    title: 'Detail UMKM',
                    subtitle: 'Inserting UMKM Details',
                    context: context,
                    route: MaterialPageRoute(builder: (context) => UmkmDetailInsertPage()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: _getMenuItem(
                    title: 'Penetapan Tim',
                    subtitle: 'Menetapkan orang-orang yang bekerja di tim',
                    context: context,
                    route: MaterialPageRoute(builder: (context) => UmkmTeamAssignPage())
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: _getMenuItem(
                    title: 'Bukti Pelaksanaan',
                    subtitle: 'Memasukkan bukti pelaksanaan',
                    context: context,
                    route: MaterialPageRoute(builder: (context) => UmkmPenilaianPage())
                  ),
                ),

                Container(
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
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
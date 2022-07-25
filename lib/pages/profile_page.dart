import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/helpers/avatar_helper.dart';
import 'package:halal_chain/helpers/user_helper.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/pages/login_page.dart';
import 'package:halal_chain/pages/profile_detail_page.dart';
import 'package:halal_chain/pages/profile_edit_auditor_page.dart';
import 'package:halal_chain/pages/profile_edit_consument_page.dart';
import 'package:halal_chain/pages/profile_edit_umkm_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  void _navigateToProfileDetail(context) {
    Navigator.of(context).pushNamed('/profile/detail');
  }

  void _navigateToEditProfile(BuildContext context, String role) async {
    final storage = FlutterSecureStorage();
    Route route;

    if (role == 'umkm') {
      final umkmDataStr = await storage.read(key: 'user_umkm');
      final umkmData = UserUmkmData.fromJSON(jsonDecode(umkmDataStr!));
      route = MaterialPageRoute(builder: (context) => ProfileEditUmkmPage(umkmData));
    }

    else if (role == 'auditor') {
      final auditorDataStr = await storage.read(key: 'user_auditor');
      final auditorData = UserAuditorData.fromJSON(jsonDecode(auditorDataStr!));
      route = MaterialPageRoute(builder: (context) => ProfileEditAuditorPage(auditorData));
    }

    else {
      final consumenDataStr = await storage.read(key: 'user_consumen');
      final consumenData = UserConsumentData.fromJSON(jsonDecode(consumenDataStr!));
      route = MaterialPageRoute(builder: (context) => ProfileEditConsumentPage(consumenData));
    }

    Navigator.of(context).push(route);
  }

  void _logout(BuildContext context) async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.of(context).pushReplacementNamed('/auth/login');
  }

  Widget _getMenuItem(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(label)
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getUserData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              String username = snapshot.data['username'];
              late String role;

              if (snapshot.data['role'] == 'umkm') role = 'UMKM';
              else if (snapshot.data['role'] == 'auditor') role = 'Auditor';
              else if (snapshot.data['role'] == 'consumen') role = 'Consument';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: NetworkImage(getAvatarUrl(username)),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(username, style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                                )),
                                SizedBox(height: 5),
                                Text(role, style: TextStyle(
                                  color: Colors.grey[600]
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(),
                    InkWell(
                      onTap: () => _navigateToProfileDetail(context),
                      child: _getMenuItem('Profile Detail', Icons.person),
                    ),
                    VerticalDivider(),
                    InkWell(
                      onTap: () => _navigateToEditProfile(context, snapshot.data['role']),
                      child: _getMenuItem('Edit Profile', Icons.edit_outlined),
                    ),
                    VerticalDivider(),
                    InkWell(
                      onTap: () => _logout(context),
                      child: _getMenuItem('Logout', Icons.logout_outlined),
                    ),
                    VerticalDivider(),
                  ],
                ),
              );
            }

            else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
                ],
              );
            }
          }
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/widgets/profile_detail_auditor_widget.dart';
import 'package:halal_chain/widgets/profile_detail_consument_widget.dart';
import 'package:halal_chain/widgets/profile_detail_umkm_widget.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({ Key? key }) : super(key: key);

  Future<UserData?> _getUserType() async {
    final storage = FlutterSecureStorage();
    final userDataStr = await storage.read(key: 'user');
    if (userDataStr == null) return null;
    return UserData.fromJSON(jsonDecode(userDataStr));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Detail')
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getUserType(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              if (userData.role == 'umkm') return ProfileDetailUmkmWidget(userData.id);
              else if (userData.role == 'auditor') return ProfileDetailAuditorWidget(userData.id);
              else return ProfileDetailConsumentWidget(userData.id);
            }

            else {
              return SizedBox(
                height: 400,
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              );
            }
          },
        ),
      ),
    );
  }
}
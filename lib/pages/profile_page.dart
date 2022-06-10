import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/helpers/avatar_helper.dart';
import 'package:halal_chain/helpers/user_helper.dart';
import 'package:halal_chain/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  void _logout(BuildContext context) async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage())
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
              else if (snapshot.data['role'] == 'consumen') role = 'Consumen';

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
                      onTap: () => _logout(context),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Icon(Icons.logout_outlined),
                            SizedBox(width: 10),
                            Text('Logout')
                          ],
                        )
                      ),
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
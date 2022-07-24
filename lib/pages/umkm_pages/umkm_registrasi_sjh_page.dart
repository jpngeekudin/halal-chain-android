import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/services/core_service.dart';

class UmkmRegistrasiSjhPage extends StatefulWidget {
  const UmkmRegistrasiSjhPage({ Key? key }) : super(key: key);

  @override
  State<UmkmRegistrasiSjhPage> createState() => _UmkmRegistrasiSjhPageState();
}

class _UmkmRegistrasiSjhPageState extends State<UmkmRegistrasiSjhPage> {

  void _daftarSJH() async {
    try {
      final core = CoreService();
      final user = await getUserData();
      final params = { 'creator_id': user!.id };
      final response = await core.genericPost(ApiList.coreRegistrationSjh, null, params);
      final snackBar = SnackBar(content: Text('Sukses melakukan registrasi'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['data'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi SJH'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 72,
            ),
            SizedBox(height: 20),
            Text('Daftarkan SJH?', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24
            )),
            SizedBox(height: 10),
            Text('Daftarkan SJH sesuai dengan data SJH yang sudah diisi?', textAlign: TextAlign.center,),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Ya'),
                onPressed: () => _daftarSJH(),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Cancel', style: TextStyle(
                  color: Colors.black
                )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[200]
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
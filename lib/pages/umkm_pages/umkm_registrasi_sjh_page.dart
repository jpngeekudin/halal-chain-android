import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/http_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
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

      showModalBottomSheet(
        context: context,
        shape: ModalBottomSheetShape,
        builder: (context) {
          return SizedBox(
            height: 400,
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 72, color: Colors.green),
                  SizedBox(height: 20),
                  Text('Registrasi Sukses', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
                  SizedBox(height: 10),
                  Text('Silahkan menunggu hasil registrasi', style: TextStyle(
                    color: Colors.grey[600]
                  ))
                ],
              ),
            ),
          );
        }
      ).then((value) {
        Navigator.of(context).pop();
      });

    }

    catch(err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['data'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> _checkRegistrationSjh() async {
    try {
      final core = CoreService();
      final user = await getUserData();
      final params = { 'umkm_id': user!.id };
      final response = await core.genericGet(ApiList.coreCheckRegistrationSjh, params);
      return response.data['registered'];
    }

    catch(err) {
      handleHttpError(context: context, err: err);
      if (err is DioError) return false;
      else throw(err.toString());
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
        child: FutureBuilder(
          future: _checkRegistrationSjh(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (!snapshot.data) {
                return Column(
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
                );
              }

              else {
                return Center(
                  child: Text('SJH has been registered', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600]
                  ))
                );
              }
            }

            else if (snapshot.hasError) {
              return Container(
                alignment: Alignment.center,
                height: 400,
                child: Text(snapshot.error.toString(), style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]
                )),
              );
            }

            else return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        ),
      )
    );
  }
}
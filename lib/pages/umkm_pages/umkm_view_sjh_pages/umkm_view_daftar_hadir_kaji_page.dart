import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewDaftarHadirKajiPage extends StatelessWidget {
  const UmkmViewDaftarHadirKajiPage({ Key? key }) : super(key: key);

  Future _getDaftarHadir({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhDaftarHasilKaji, params);
      final daftarHadir = SjhDaftarHadirKaji.fromJSON(res.data['daftar_hasil_kaji']);
      return daftarHadir;
    }

    catch(err, trace) {
      logger.e(err);
      logger.e(trace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Hadir Kaji'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getDaftarHadir(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final SjhDaftarHadirKaji daftarHadir = snapshot.data;
                final valueStyle = TextStyle(
                  fontWeight: FontWeight.bold
                );

                return ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text('Tanggal'),
                      trailing: Text(defaultDateFormat.format(daftarHadir.tanggal), style: valueStyle),
                    ),
                    Container(
                      color: Colors.grey[200],
                      height: 20
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text('Daftar Hadir', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )),
                    ),
                    ...daftarHadir.orangList.map((orang) {
                      return ListTile(
                        title: Text(orang.nama),
                        trailing: Text(orang.jabatan),
                      );
                    }).toList(),
                    Container(
                      color: Colors.grey[200],
                      height: 20
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text('Daftar Pembahasan', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )),
                    ),
                    ...daftarHadir.pembahasanList.map((pembahsan) {
                      return ListTile(
                        title: Text(pembahsan.pembahasan),
                        subtitle: Text(pembahsan.perbaikan, style: TextStyle(
                          color: Colors.grey[600]
                        )),
                      );
                    })
                  ],
                );
              }

              else if (snapshot.hasError) {
                return Container(
                  alignment: Alignment.center,
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
            },
          ),
        ),
      ),
    );
  }
}
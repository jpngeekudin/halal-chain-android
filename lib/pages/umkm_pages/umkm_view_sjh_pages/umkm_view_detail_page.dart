import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewDetailPage extends StatelessWidget {
  const UmkmViewDetailPage({ Key? key }) : super(key: key);

  Future<SjhUmkmDetail> _getUmkmDetail({
    required BuildContext context,
  }) async {
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhDetailUmkm, params);
      final umkmDetail = SjhUmkmDetail.fromJSON(res.data['detail_umkm']);
      return umkmDetail;
    }

    catch(err, trace) {
      final logger = Logger();
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
        title: Text('UMKM Detail'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getUmkmDetail(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final SjhUmkmDetail umkmDetail = snapshot.data;
                return ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text('Nama Ketua'),
                      trailing: Text(umkmDetail.namaKetua),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('No. Telp. Ketua'),
                      trailing: Text(umkmDetail.noTelpKetua),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('No. KTP Ketua'),
                      trailing: Text(umkmDetail.noKtpKetua),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Nama Penanggungjawab'),
                      trailing: Text(umkmDetail.namaPenanggungjawab),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Logo Perusahaan'),
                      trailing: Image.network(
                        ApiList.utilLoadFile + '/' + umkmDetail.logoPerusahaan,
                        width: 200
                      )
                    ),
                    Divider(),
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
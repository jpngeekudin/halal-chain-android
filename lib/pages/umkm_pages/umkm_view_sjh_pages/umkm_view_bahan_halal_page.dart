import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewBahanHalalPage extends StatelessWidget {
  const UmkmViewBahanHalalPage({ Key? key }) : super(key: key);

  Future<List<SjhBahanHalalItem>> _getBahanHalal({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhBarangHalal, params);
      final bahanHalalList = res.data['daftar_bahan_halal'].map<SjhBahanHalalItem>((json) => SjhBahanHalalItem.fromJSON(json)).toList();
      return bahanHalalList;
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
        title: Text('Bahan Halal'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getBahanHalal(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<SjhBahanHalalItem> bahanHalalList = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: bahanHalalList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final bahanHalal = bahanHalalList[index];
                    final styleBold = TextStyle(fontWeight: FontWeight.bold);
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bahanHalal.namaMerk, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Nama Negara'),
                              SizedBox(width: 10),
                              Text(bahanHalal.namaNegara, style: styleBold)
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Pemasok'),
                              SizedBox(width: 10),
                              Text(bahanHalal.pemasok, style: styleBold)
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Penerbit'),
                              SizedBox(width: 10),
                              Text(bahanHalal.penerbit, style: styleBold)
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Nomor'),
                              SizedBox(width: 10),
                              Text(bahanHalal.nomor, style: styleBold)
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Masa Berlaku'),
                              SizedBox(width: 10),
                              Text(defaultDateFormat.format(bahanHalal.masaBerlaku), style: styleBold)
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Dokumen Lain'),
                              SizedBox(width: 10),
                              Text(bahanHalal.dokumenLain, style: styleBold)
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Keterangan'),
                              SizedBox(width: 10),
                              Text(bahanHalal.keterangan, style: styleBold)
                            ],
                          ),
                        ],
                      ),
                    );
                  },
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
      )
    );
  }
}
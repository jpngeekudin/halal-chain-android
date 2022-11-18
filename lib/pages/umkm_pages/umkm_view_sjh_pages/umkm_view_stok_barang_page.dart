import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewStokBarangPage extends StatelessWidget {
  const UmkmViewStokBarangPage({ Key? key }) : super(key: key);

  Future<List<SjhStokBarangItem>> _getStokBarang({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhStokBarang, params);
      final bahanList = res.data['stok_barang'].map<SjhStokBarangItem>((json) => SjhStokBarangItem.fromJSON(json)).toList();
      return bahanList;
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
        title: Text('Stok Barang'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getStokBarang(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<SjhStokBarangItem> bahanList = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: bahanList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final bahan = bahanList[index];
                    final styleBold = TextStyle(fontWeight: FontWeight.bold);
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bahan.namaBahan, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          )),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Tanggal Beli'),
                              SizedBox(width: 10),
                              Text(defaultDateFormat.format(bahan.tanggalBeli), style: styleBold),
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Jumlah Bahan'),
                              SizedBox(width: 10),
                              Text(bahan.jumlahBahan, style: styleBold),
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Jumlah Bahan Keluar'),
                              SizedBox(width: 10),
                              Text(bahan.jumlahKeluar, style: styleBold),
                            ],
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Jumlah Sisa'),
                              SizedBox(width: 10),
                              Text(bahan.stokSisa, style: styleBold),
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
      ),
    );
  }
}
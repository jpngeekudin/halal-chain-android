import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewProduksiPage extends StatelessWidget {
  const UmkmViewProduksiPage({ Key? key }) : super(key: key);

  Future<List<SjhProduksiItem>> _getProduksi({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhStokProduksi, params);
      final produksiList = res.data['form_produksi'].map<SjhProduksiItem>((json) => SjhProduksiItem.fromJSON(json)).toList();
      return produksiList;
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
        title: Text('Stok Produksi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getProduksi(context: context),
            builder:(context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<SjhProduksiItem> produksiList = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: produksiList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder:(context, index) {
                    final produksi = produksiList[index];
                    final styleBold = TextStyle(fontWeight: FontWeight.bold);
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(produksi.namaProduk, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Tanggal Produksi'),
                              SizedBox(width: 10),
                              Text(defaultDateFormat.format(produksi.tanggalProduksi), style: styleBold),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Jumlah Awal'),
                              SizedBox(width: 10),
                              Text(produksi.jumlahAwal, style: styleBold),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Jumlah Keluar'),
                              SizedBox(width: 10),
                              Text(produksi.jumlahProdukKeluar, style: styleBold),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Sisa Stok'),
                              SizedBox(width: 10),
                              Text(produksi.sisaStok, style: styleBold),
                            ],
                          ),
                          SizedBox(height: 5),
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
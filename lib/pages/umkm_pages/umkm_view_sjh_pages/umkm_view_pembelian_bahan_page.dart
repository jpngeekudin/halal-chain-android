import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewPembelianBahanPage extends StatelessWidget {
  const UmkmViewPembelianBahanPage({
    Key? key,
    this.bahanType = 'non-import'
  }) : super(key: key);

  final String bahanType;

  Future<List<SjhPembelianBahanItem>> _getPembelianBahan({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final url = bahanType == 'import' ? ApiList.sjhPembelianImport : ApiList.sjhPembelian;
      final res = await core.genericGet(url, params);
      final List<dynamic> jsonList = bahanType == 'import' ? res.data['pembelian_import'] : res.data['pembelian'];
      final bahanList = jsonList.map<SjhPembelianBahanItem>((json) => SjhPembelianBahanItem.fromJSON(json)).toList();
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
        title: Text('Pembelian dan Pemeriksaan Bahan')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getPembelianBahan(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<SjhPembelianBahanItem> bahanList = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: bahanList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final bahan = bahanList[index];
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bahan.namaDanMerk, style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Negara:', style: TextStyle(
                                color: Colors.grey[600]
                              )),
                              SizedBox(width: 10),
                              Text(bahan.namaDanNegara)
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Halal:', style: TextStyle(
                                color: Colors.grey[600]
                              )),
                              SizedBox(width: 10),
                              Icon(
                                bahan.halal ? Icons.check_circle_outline : Icons.remove_circle_outline,
                                color: bahan.halal ? Theme.of(context).primaryColor : Colors.red,
                                size: 14,
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Beli:', style: TextStyle(
                                color: Colors.grey[600]
                              )),
                              SizedBox(width: 10),
                              Text(defaultDateFormat.format(bahan.tanggal))
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Expired:', style: TextStyle(
                                color: Colors.grey[600]
                              )),
                              SizedBox(width: 10),
                              Text(defaultDateFormat.format(bahan.expBahan))
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
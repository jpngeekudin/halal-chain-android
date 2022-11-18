import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewPemusnahanPage extends StatelessWidget {
  const UmkmViewPemusnahanPage({ Key? key }) : super(key: key);

  Future<List<SjhPemusnahanItem>> _getPemusnahan({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhFormPemusnahan, params);
      final pemusnahanList = res.data['form_pemusnahan'].map<SjhPemusnahanItem>((json) => SjhPemusnahanItem.fromJSON(json)).toList();
      return pemusnahanList;
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
        title: Text('Pemusnahan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getPemusnahan(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<SjhPemusnahanItem> pemusnahanList = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: pemusnahanList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final pemusnahan = pemusnahanList[index];
                    final styleBold = TextStyle(fontWeight: FontWeight.bold);
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pemusnahan.namaProduk, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Tanggal Produksi'),
                              SizedBox(width: 10,),
                              Text(defaultDateFormat.format(pemusnahan.tanggalProduksi), style: styleBold),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Tanggal Pemusnahan'),
                              SizedBox(width: 10,),
                              Text(defaultDateFormat.format(pemusnahan.tanggalPemusnahan), style: styleBold),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Jumlah'),
                              SizedBox(width: 10,),
                              Text(pemusnahan.jumlah, style: styleBold),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Penyebab'),
                              SizedBox(width: 10,),
                              Text(pemusnahan.penyebab, style: styleBold),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Penanggungjawab'),
                              SizedBox(width: 10,),
                              Text(pemusnahan.penananggungjawab, style: styleBold),
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
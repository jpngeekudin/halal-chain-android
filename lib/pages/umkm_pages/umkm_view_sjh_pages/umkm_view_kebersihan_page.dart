import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewKebersihanPage extends StatelessWidget {
  const UmkmViewKebersihanPage({ Key? key }) : super(key: key);

  Future<List<SjhKebersihanItem>> _getKebersihan({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhFormKebersihan, params);
      final kebersihanList = res.data['form_pengecekan_kebersihan'].map<SjhKebersihanItem>((json) => SjhKebersihanItem.fromJSON(json)).toList();
      return kebersihanList;
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
        title: Text('Pengecekan Kebersihan')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getKebersihan(context: context),
            builder:(context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<SjhKebersihanItem> kebersihanList = snapshot.data;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: kebersihanList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final kebersihan = kebersihanList[index];
                    final styleBold = TextStyle(fontWeight: FontWeight.bold);
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(defaultDateFormat.format(kebersihan.tanggal), style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Produksi'),
                              SizedBox(width: 10),
                              Text(kebersihan.produksi ? 'Ya' : 'Tidak', style: styleBold,),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Gudang'),
                              SizedBox(width: 10),
                              Text(kebersihan.gudang ? 'Ya' : 'Tidak', style: styleBold,),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Mesin'),
                              SizedBox(width: 10),
                              Text(kebersihan.mesin ? 'Ya' : 'Tidak', style: styleBold,),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Kendaraan'),
                              SizedBox(width: 10),
                              Text(kebersihan.kendaraan ? 'Ya' : 'Tidak', style: styleBold,),
                            ],
                          ),
                          SizedBox(height: 5),
                          Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Text('Penanggungjawab'),
                              SizedBox(width: 10),
                              Text(kebersihan.penanggungjawab, style: styleBold,),
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
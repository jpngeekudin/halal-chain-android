import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewEvaluasiPage extends StatelessWidget {
  const UmkmViewEvaluasiPage({ Key? key }) : super(key: key);

  Future<SjhEvaluasi> _getEvaluasi({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhJawabanEvaluasi, params);
      final evaluasi = SjhEvaluasi.fromJSON(res.data['jawaban_evaluasi']);
      return evaluasi;
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
        title: Text('Evaluasi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getEvaluasi(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final SjhEvaluasi evaluasi = snapshot.data;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text('Nama', style: TextStyle(
                            fontWeight: FontWeight.bold
                          )),
                          SizedBox(height: 10),
                          Text(evaluasi.nama)
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text('Tanggal', style: TextStyle(
                            fontWeight: FontWeight.bold
                          )),
                          SizedBox(height: 10),
                          Text(defaultDateFormat.format(evaluasi.tanggal))
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text('Jawaban', style: TextStyle(
                        fontWeight: FontWeight.bold
                      )),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: evaluasi.data.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final jawaban = evaluasi.data['${index+1}'];
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Soal ${index+1}'),
                              Text(jawaban!.toUpperCase(), style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ))
                            ],
                          ),
                        );
                      },
                    ),
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
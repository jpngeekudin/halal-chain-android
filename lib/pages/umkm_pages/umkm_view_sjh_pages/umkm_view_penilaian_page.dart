import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewPenilaianPage extends StatelessWidget {
  const UmkmViewPenilaianPage({ Key? key }) : super(key: key);

  Future<SjhBuktiPelaksanaan> _getPenetapanTim({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.sjhBuktiPelaksanaan, params);
      final buktiPelaksanaan = SjhBuktiPelaksanaan.fromJSON(res.data['bukti_pelaksanaan']);
      return buktiPelaksanaan;
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
        title: Text('Bukti Pelaksanaan'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getPenetapanTim(context: context),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final SjhBuktiPelaksanaan bukti = snapshot.data;
              return ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('Tanggal Pelaksanaan'),
                    trailing: Text(defaultDateFormat.format(bukti.tanggalPelaksanaan)),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Pemateri'),
                    trailing: Text(bukti.pemateri),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Anggota', style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                        SizedBox(height: 20),
                        ...bukti.data.map((anggota) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    Text(anggota.nama, style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                    SizedBox(height: 10),
                                    Text(anggota.posisi, style: TextStyle(
                                      color: Colors.grey[600]
                                    ))
                                  ],
                                ),
                                Text(anggota.nilai.toString(), style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Theme.of(context).primaryColor,
                                ))
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  )
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
      )
    );
  }
}
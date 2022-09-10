import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/models/qr_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UmkmQrViewPage extends StatefulWidget {
  const UmkmQrViewPage({Key? key}) : super(key: key);

  @override
  State<UmkmQrViewPage> createState() => _UmkmQrViewPageState();
}

class _UmkmQrViewPageState extends State<UmkmQrViewPage> {

  final _logger = Logger();

  Future _getQrDetail() async {
    try {
      final userData = await getUserData();
      final core = CoreService();
      final params = { 'umkm_id': userData?.id };
      final response = await core.genericGet(ApiList.coreQrDetail, params);
      final qrDetail = QrDetail.fromJson(response.data);
      _logger.i(qrDetail);
      return qrDetail;
    }

    catch(err, trace) {
      _logger.e(trace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View QR'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _getQrDetail(),
          builder:(context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              QrDetail qrDetail = snapshot.data;
              final umkmId = qrDetail.profile.id;
              final certified = qrDetail.core.certificate.status;
              final certificateImageUrl = ApiList.utilLoadFile + '?image_name=' + qrDetail.core.certificate.data;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    QrImage(
                      data: umkmId,
                      version: QrVersions.auto,
                      size: 200
                    ),
                    SizedBox(height: 10),
                    Text(qrDetail.profile.companyName, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    )),
                    SizedBox(height: 10),
                    certified
                      ? Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green),
                          SizedBox(width: 5),
                          Text('Certified')
                        ],
                      )
                      : Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.close_rounded, color: Colors.red),
                          SizedBox(width: 5),
                          Text('Not Certified')
                        ],
                      ),
                    SizedBox(height: 50),
                    Image.network(certificateImageUrl, width: 400,),
                    SizedBox(height: 50)
                  ],
                ),
              );
            }

            else {
              return Center(
                child: CircularProgressIndicator()
              );
            }
          },
        ),
      ),
    );
  }
}
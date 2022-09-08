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
        child: Center(
          child: FutureBuilder(
            future: _getQrDetail(),
            builder:(context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                QrDetail qrDetail = snapshot.data;
                return Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    QrImage(
                      data: 'hibikekoinouta',
                      version: QrVersions.auto,
                      size: 200
                    ),
                    SizedBox(height: 10),
                    Text(qrDetail.profile.companyName, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    )),
                  ],
                );
              }

              else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
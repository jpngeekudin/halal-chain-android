import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/models/qr_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class UmkmQrViewPage extends StatefulWidget {
  const UmkmQrViewPage({Key? key}) : super(key: key);

  @override
  State<UmkmQrViewPage> createState() => _UmkmQrViewPageState();
}

class _UmkmQrViewPageState extends State<UmkmQrViewPage> {
  final _logger = Logger();
  GlobalKey _globalKey = GlobalKey();

  Future _getQrDetail() async {
    try {
      final userData = await getUserData();
      final core = CoreService();
      final params = {'umkm_id': userData?.id};
      final response = await core.genericGet(ApiList.coreQrDetail, params);
      final qrDetail = QrDetail.fromJson(response.data);
      _logger.i(qrDetail);
      return qrDetail;
    } catch (err, trace) {
      _logger.e(trace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future _shareQr(String qrData) async {
    // try {
    //   final image = await QrPainter(
    //     data: qrData,
    //     version: QrVersions.auto,
    //   ).toImage(200);
    // }

    // catch(err) {

    // }

    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes!);

      Share.shareFiles([file.path]);

      // final channel = MethodChannel('channel:me.cocode.share/share');
      // channel.invokeMethod('shareFile', 'qr.png');
    } catch (err, trace) {
      final logger = Logger();
      logger.e(err);
      logger.e(trace);
      throw (err.toString());
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
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              QrDetail qrDetail = snapshot.data;

              if (qrDetail.core != null) {
                final umkmId = qrDetail.profile.id;
                final certified = qrDetail.core!.certificate.status;
                final certificateImageUrl = ApiList.utilLoadFile +
                    '?image_name=' +
                    qrDetail.core!.certificate.data;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      RepaintBoundary(
                        key: _globalKey,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: QrImageView(
                              data: umkmId,
                              version: QrVersions.auto,
                              size: 200),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(qrDetail.profile.companyName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      SizedBox(height: 10),
                      certified
                          ? Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.green),
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
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.share, size: 16),
                            SizedBox(width: 10),
                            Text('Share'),
                          ],
                        ),
                        onPressed: () => _shareQr(umkmId),
                      ),
                      SizedBox(height: 50),
                      Image.network(
                        certificateImageUrl,
                        width: 400,
                      ),
                      SizedBox(height: 50)
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('UMKM has not been certified',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400])),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(snapshot.error.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400])));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

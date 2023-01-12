import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/http_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/models/qr_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/qr_trace_widget.dart';
import 'package:halal_chain/widgets/review_form_widget.dart';
import 'package:halal_chain/widgets/review_list_widget.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class ConsumentQrDetailPage extends StatefulWidget {
  const ConsumentQrDetailPage({Key? key}) : super(key: key);

  @override
  State<ConsumentQrDetailPage> createState() => _ConsumentQrDetailPageState();
}

class _ConsumentQrDetailPageState extends State<ConsumentQrDetailPage> {

  String _umkmId = '';

  Future<QrDetail?> _getQrDetail() async {
    if (_umkmId.isEmpty) return null;
    
    try {
      final core = CoreService();
      final params = { 'umkm_id': _umkmId };
      final response = await core.genericGet(ApiList.coreQrDetail, params);
      final qrDetail = QrDetail.fromJson(response.data);
      return qrDetail;
    }

    catch(err, trace) {
      final logger = Logger();
      logger.e(err);
      logger.e(trace);
      
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw(message);
    }
  }

  Widget _getTableCell(Widget content) {
    return TableCell(
      child: Container(
        padding: EdgeInsets.all(10),
        child: content
      ),
    );
  }

  void _openReviewModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: ModalBottomSheetShape,
      builder: (context) {
        return ReviewFormWidget(
          umkmId: _umkmId,
          onSuccess: () {
            Navigator.of(context).pop();
            setState(() {});
          },
        );
      }
    );
  }

  Future _downloadCertificate() async {
    final logger = Logger();
    try {
      Directory directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) directory = (await getExternalStorageDirectory())!;

      final dio = Dio();
      final params = { 'umkm_id': _umkmId };
      final res = await dio.get(ApiList.loadCertificate,
      queryParameters: params,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500
        )
      );

      String contentDisposition = res.headers.value('content-disposition')!;
      String filename = contentDisposition.substring(22, contentDisposition.length-1);
      String fullPath = directory.path + '/$filename';

      final file = await File(fullPath).create();
      file.writeAsBytesSync(res.data);

      // var raf = file.openSync(mode: FileMode.write);
      // raf.writeFromSync(res.data);
      // await raf.close();

      final snackBar = SnackBar(content: Text('Success downloading file at $fullPath'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      String message = 'Certificate not found!';
      if (err is DioError) {
        logger.i(err.response?.data);
        message = err.response?.data['message'] ?? message;
      }
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        _umkmId = args['umkmId'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _getQrDetail(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              QrDetail data = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(data.profile.companyName, style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Text(data.profile.productName),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[400]!,
                            )
                          ),
                          child: data.core?.certificate.status ?? false
                            ? Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                                SizedBox(width: 5),
                                Text('Certified Halal')
                              ],
                            )
                            : Wrap(
                              children: [
                                Icon(Icons.close, color: Colors.red, size: 16),
                                SizedBox(width: 5),
                                Text('Not Certified')
                              ]
                          ),
                        ),
                      ),
                      
                      if (data.core?.certificate.status ?? false) ...[
                        SizedBox(height: 20),
                        Image.network(ApiList.utilLoadFile + '?image_name=' + data.core!.certificate.data),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Text('Issued', style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )),
                                SizedBox(height: 10),
                                Text(defaultDateFormat.format(data.core!.certificate.createdDate))
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Text('Expired', style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )),
                                SizedBox(height: 10),
                                Text(defaultDateFormat.format(data.core!.certificate.expiredDate))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30)
                      ],

                      // pembelian
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daftar Pembelian', style: TextStyle(
                              fontWeight: FontWeight.bold
                            )),
                            SizedBox(height: 10),
                            Table(
                              border: TableBorder.all(
                                color: Theme.of(context).dividerColor
                              ),
                              columnWidths: {
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth()
                              },
                              children: [
                                TableRow(
                                  children: [
                                    _getTableCell(
                                      Text('Nama', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                    _getTableCell(
                                      Text('Halal', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                    _getTableCell(
                                      Text('Expired', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                  ]
                                ),
                                ...data.pembelian.map((pembelian) {
                                  return TableRow(
                                    children: [
                                      _getTableCell(
                                        Text(pembelian.namaDanMerk)
                                      ),
                                      _getTableCell(
                                        Text(pembelian.halal ? 'Halal' : 'Tidak')
                                      ),
                                      _getTableCell(
                                        Text(defaultDateFormat.format(pembelian.expBahan))
                                      )
                                    ]
                                  );
                                })
                              ],
                            )
                          ],
                        ),
                      ),

                      // pembelian import
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daftar Pembelian Import', style: TextStyle(
                              fontWeight: FontWeight.bold
                            )),
                            SizedBox(height: 10),
                            Table(
                              border: TableBorder.all(
                                color: Theme.of(context).dividerColor
                              ),
                              columnWidths: {
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth()
                              },
                              children: [
                                TableRow(
                                  children: [
                                    _getTableCell(
                                      Text('Nama', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                    _getTableCell(
                                      Text('Halal', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                    _getTableCell(
                                      Text('Expired', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                  ]
                                ),
                                ...data.pembelianImport.map((pembelian) {
                                  return TableRow(
                                    children: [
                                      _getTableCell(
                                        Text(pembelian.namaDanMerk)
                                      ),
                                      _getTableCell(
                                        Text(pembelian.halal ? 'Halal' : 'Tidak')
                                      ),
                                      _getTableCell(
                                        Text(defaultDateFormat.format(pembelian.expBahan))
                                      )
                                    ]
                                  );
                                })
                              ],
                            )
                          ],
                        ),
                      ),

                      // stok barang
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daftar Stok Barang', style: TextStyle(
                              fontWeight: FontWeight.bold
                            )),
                            SizedBox(height: 10),
                            Table(
                              border: TableBorder.all(
                                color: Theme.of(context).dividerColor
                              ),
                              columnWidths: {
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth()
                              },
                              children: [
                                TableRow(
                                  children: [
                                    _getTableCell(
                                      Text('Nama', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                    _getTableCell(
                                      Text('Sisa', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                    _getTableCell(
                                      Text('Beli', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ))
                                    ),
                                  ]
                                ),
                                ...data.stokBarang.map((stok) {
                                  return TableRow(
                                    children: [
                                      _getTableCell(
                                        Text(stok.namaBahan)
                                      ),
                                      _getTableCell(
                                        Text(stok.stokSisa)
                                      ),
                                      _getTableCell(
                                        Text(defaultDateFormat.format(stok.tanggalBeli))
                                      )
                                    ]
                                  );
                                })
                              ],
                            )
                          ],
                        ),
                      ),

                      // product trace
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: QrTraceWidget(umkmId: _umkmId),
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _downloadCertificate(),
                            child: Text('Download Certificate'),
                          ),
                        )
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _openReviewModal(),
                            child: Text('Write Review'),
                          ),
                        )
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: ReviewListWidget(umkmId: _umkmId),
                      )
                    ],
                  ),
                ),
              );
            }

            else if (snapshot.hasError) {
              final message = snapshot.error.toString();
              return Center(
                child: Text(message, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                )),
              );
            }

            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        ),
      ),
    );
  }
}
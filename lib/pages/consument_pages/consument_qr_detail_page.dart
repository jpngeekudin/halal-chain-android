import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/qr_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class ConsumentQrDetailPage extends StatefulWidget {
  const ConsumentQrDetailPage({Key? key}) : super(key: key);

  @override
  State<ConsumentQrDetailPage> createState() => _ConsumentQrDetailPageState();
}

class _ConsumentQrDetailPageState extends State<ConsumentQrDetailPage> {

  Future<QrDetail?> _getQrDetail() async {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final umkmId = args['umkmId'];

    try {
      final core = CoreService();
      final params = { 'umkm_id': umkmId };
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
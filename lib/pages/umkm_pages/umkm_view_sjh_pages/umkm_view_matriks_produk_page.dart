import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/models/sjh_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmViewMatriksProdukPage extends StatelessWidget {
  const UmkmViewMatriksProdukPage({Key? key}) : super(key: key);

  Future<List<SjhMatriksItem>> _getMatriks({
    required BuildContext context,
  }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = {'creator_id': user?.id};
      final res = await core.genericGet(ApiList.sjhMatriksProduk, params);
      final matriksList = res.data['matriks_produk']
          .map<SjhMatriksItem>((json) => SjhMatriksItem.fromJSON(json))
          .toList();
      return matriksList;
    } catch (err, trace) {
      logger.e(err);
      logger.e(trace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      rethrow;
    }
  }

  Widget _getMatriksTable({
    required List<SjhMatriksItem> matriks,
    required BuildContext context,
  }) {
    List<String> listProduk;
    if (matriks.isEmpty) {
      listProduk = List.empty();
    } else {
      listProduk = matriks[0].listBahan.map((bahan) => bahan.barang).toList();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Theme.of(context).dividerColor),
        defaultColumnWidth: IntrinsicColumnWidth(),
        children: [
          TableRow(children: [
            TableCell(
                child: Container(
              padding: EdgeInsets.all(10),
              child: Text('Nama Bahan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )),
            ...listProduk.map((produk) => TableCell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(produk,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ))
          ]),
          ...matriks.map((matrik) => TableRow(children: [
                TableCell(
                    child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(matrik.namaBahan),
                )),
                ...listProduk.map((produk) {
                  bool enabled = matrik.listBahan
                          .firstWhere((element) => element.barang == produk)
                          .status ??
                      false;

                  return TableCell(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: enabled
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.close, color: Colors.red),
                    ),
                  );
                })
              ]))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Matriks Produk'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getMatriks(context: context),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<SjhMatriksItem> matriksList = snapshot.data;
                return Container(
                    padding: EdgeInsets.all(20),
                    child: _getMatriksTable(
                        matriks: matriksList, context: context));
              } else if (snapshot.hasError) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(snapshot.error.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600])),
                );
              } else
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
            },
          ),
        )));
  }
}

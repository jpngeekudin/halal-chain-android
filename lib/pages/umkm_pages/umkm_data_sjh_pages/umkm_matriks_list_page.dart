import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/models/umkm_doc_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/wrap_horizontal.dart';
import 'package:logger/logger.dart';

class UmkmMatriksListPage extends StatelessWidget {
  const UmkmMatriksListPage({Key? key, this.enableCreate = true})
      : super(key: key);

  final bool enableCreate;

  void _navigateToCreate(BuildContext context) {
    Navigator.of(context).pushNamed('/umkm/data-sjh/matriks/create');
  }

  void _openDetailModal({
    required BuildContext context,
    required UmkmDocMatriks matriks,
  }) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: ModalBottomSheetShape,
        builder: (context) {
          return getModalBottomSheetWrapper(
              context: context,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(matriks.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    ...matriks.data.map((item) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item.namaBahan,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 5),
                                DefaultTextStyle(
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                    child: wrapHorizontal([
                                      Text('List Produk:'),
                                      SizedBox(width: 5),
                                      ...item.listBarang.map((produk) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: Text(produk.barang + ','),
                                        );
                                      })
                                    ])),
                              ]),
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                  ],
                ),
              ));
        });
  }

  Future<List<UmkmDocMatriks>> _getMatriksList(
      BuildContext context, String? id) async {
    final logger = Logger();
    try {
      String userId;
      if (id != null) {
        userId = id;
      } else {
        final currentUser = await getUserData();
        userId = currentUser!.id;
      }
      final core = CoreService();
      final params = {'umkm_id': userId, 'type': 'matrix'};

      final res = await core.genericGet(ApiList.umkmGroupingData, params);
      List<UmkmDocMatriks> matriksList = [];
      res.data.forEach((doc) {
        doc['data'].forEach((data) {
          final matriks = UmkmDocMatriks.fromJson(data);
          matriksList.add(matriks);
        });
      });
      return matriksList;
    } catch (err, trace) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      logger.e(err);
      logger.e(trace);

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text(message),
              ));

      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String? userId = args?['id'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Matriks List'),
          actions: [
            if (enableCreate)
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add Matriks',
                onPressed: () => _navigateToCreate(context),
              )
          ],
        ),
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: _getMatriksList(context, userId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<UmkmDocMatriks> matriksList = snapshot.data;
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: matriksList.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final matriks = matriksList[index];
                          return InkWell(
                            onTap: () => _openDetailModal(
                                context: context, matriks: matriks),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(matriks.id,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                  SizedBox(height: 10),
                                  DefaultTextStyle(
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey[600]),
                                    child: wrapHorizontal([
                                      wrapHorizontal([
                                        Icon(Icons.file_copy,
                                            color: Colors.grey[600], size: 12),
                                        SizedBox(width: 5),
                                        Text(matriks.docId)
                                      ])
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError)
                      return Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: Text('Terjadi kesalahanan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600])),
                      );
                    else
                      return Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                  },
                ),
              )),
        ));
  }
}

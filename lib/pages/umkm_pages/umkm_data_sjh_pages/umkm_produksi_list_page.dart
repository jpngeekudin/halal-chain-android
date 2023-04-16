import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/models/umkm_doc_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/wrap_horizontal.dart';
import 'package:logger/logger.dart';

class UmkmProduksiListPage extends StatelessWidget {
  const UmkmProduksiListPage({Key? key, this.enableCreate = true})
      : super(key: key);

  final bool enableCreate;

  Future<List<UmkmDocProduksi>> _getProduksiList(
      BuildContext context, String? id) async {
    final logger = Logger();
    try {
      String userId;
      if (id != null)
        userId = id;
      else {
        final currentUser = await getUserData();
        userId = currentUser!.id;
      }
      
      final core = CoreService();
      final params = {'umkm_id': userId, 'type': 'produksi'};

      final res = await core.genericGet(ApiList.umkmGroupingData, params);
      List<UmkmDocProduksi> produksiList = [];
      res.data.forEach((doc) {
        doc['data'].forEach((data) {
          final produksi = UmkmDocProduksi.fromJson(data);
          produksiList.add(produksi);
        });
      });
      return produksiList;
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

  void _openDetailModal({
    required BuildContext context,
    required UmkmDocProduksi produksi,
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
                      child: Text(produksi.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    ...produksi.data.map((item) {
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
                                Text(item.namaProduk,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                wrapHorizontal([
                                  Icon(Icons.calendar_month,
                                      color: Colors.grey[600], size: 12),
                                  SizedBox(width: 5),
                                  Text(
                                      defaultDateFormat
                                          .format(item.tanggalProduksi),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ))
                                ]),
                                SizedBox(height: 5),
                                DefaultTextStyle(
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                    child: wrapHorizontal([
                                      Text('In: ${item.jumlahAwal}'),
                                      SizedBox(width: 5),
                                      Text('Out: ${item.jumlahProdukKeluar}'),
                                      SizedBox(width: 5),
                                      Text('Current: ${item.sisaStok}'),
                                    ]))
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

  void _navigateToCreate(BuildContext context) {
    Navigator.of(context).pushNamed('/umkm/data-sjh/produksi/create');
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String? userId = args?['id'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Produksi List'),
          actions: [
            if (enableCreate)
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add Produksi',
                onPressed: () => _navigateToCreate(context),
              )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
              child: FutureBuilder(
                future: _getProduksiList(context, userId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<UmkmDocProduksi> produksiList = snapshot.data;
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: produksiList.length,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final produksi = produksiList[index];
                        return InkWell(
                          onTap: () => _openDetailModal(
                              context: context, produksi: produksi),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(produksi.id,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                                SizedBox(height: 10),
                                DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[600]),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      Wrap(
                                          direction: Axis.horizontal,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Icon(Icons.file_copy,
                                                color: Colors.grey[600],
                                                size: 12),
                                            SizedBox(width: 5),
                                            Text(produksi.docId)
                                          ])
                                    ],
                                  ),
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
            ),
          ),
        ));
  }
}

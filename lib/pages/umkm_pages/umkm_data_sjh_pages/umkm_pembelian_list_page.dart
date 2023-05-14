import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/models/umkm_doc_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmPembelianListPage extends StatelessWidget {
  const UmkmPembelianListPage(
      {Key? key, this.typeBahan = 'non-import', this.enableCreate = true})
      : super(key: key);

  final bool enableCreate;
  final String typeBahan;

  void _navigateToCreate(BuildContext context) {
    String url;
    if (typeBahan == 'non-import')
      url = '/umkm/data-sjh/pembelian-bahan/create';
    else
      url = '/umkm/data-sjh/pembelian-bahan-import/create';
    Navigator.of(context).pushNamed(url);
  }

  Widget _getDetailRow(String label, String value) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  void _openDetailModal({
    required BuildContext context,
    required UmkmDocPembelian pembelian,
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
                      child: Text(pembelian.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    ...pembelian.data.map((item) {
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
                                Wrap(
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(item.namaDanMerk,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    SizedBox(width: 5),
                                    Icon(
                                      item.halal.toLowerCase() == 'true'
                                          ? Icons.check_circle
                                          : Icons.remove_circle,
                                      color: item.halal.toLowerCase() == 'true'
                                          ? Colors.green
                                          : Colors.red,
                                      size: 12,
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(item.namaDanNegara,
                                    style: TextStyle(color: Colors.grey[600]))
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

  Future<List<UmkmDocPembelian>> _getPembelianList(
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
      final params = {
        'umkm_id': userId,
        'type': typeBahan == 'import' ? 'pembelian_import' : 'pembelian'
      };

      final res = await core.genericGet(ApiList.umkmGroupingData, params);
      List<UmkmDocPembelian> pembelianList = [];
      res.data.forEach((doc) {
        doc['data'].forEach((data) {
          final pembelian = UmkmDocPembelian.fromJson(data);
          pembelianList.add(pembelian);
        });
      });
      return pembelianList;
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
    String? userId = args?['id'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Pembelian List'),
          actions: [
            if (enableCreate)
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add Pembelian',
                onPressed: () => _navigateToCreate(context),
              )
          ],
        ),
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: _getPembelianList(context, userId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<UmkmDocPembelian> pembelianList = snapshot.data;
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: pembelianList.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final pembelian = pembelianList[index];
                          return InkWell(
                            onTap: () => _openDetailModal(
                                context: context, pembelian: pembelian),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pembelian.id,
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
                                              Text(pembelian.docId)
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
              )),
        ));
  }
}

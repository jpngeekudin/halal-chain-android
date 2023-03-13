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

class UmkmBahanHalalListPage extends StatelessWidget {
  const UmkmBahanHalalListPage({Key? key, this.enableCreate = true})
      : super(key: key);
  final bool enableCreate;

  void _navigateToCreate(BuildContext context) {
    Navigator.of(context).pushNamed('/umkm/data-sjh/bahan-halal/create');
  }

  void _openDetailModal({
    required BuildContext context,
    required UmkmDocBahanHalal bahan,
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
                      child: Text(bahan.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    ...bahan.data.map((item) {
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
                                Text(item.namaMerk,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 5),
                                Text(item.pemasok,
                                    style: TextStyle(color: Colors.grey[600])),
                                SizedBox(height: 5),
                                wrapHorizontal([
                                  Icon(Icons.calendar_month, size: 12),
                                  SizedBox(width: 5),
                                  if (item.masaBerlaku != null)
                                    Text(defaultDateFormat
                                        .format(item.masaBerlaku!)),
                                ])
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

  Future<List<UmkmDocBahanHalal>> _getBahanList(
      BuildContext context, String? id) async {
    final logger = Logger();
    try {
      String userId;
      if (id != null) {
        userId = id;
      } else {
        final currentUser = await getUserData();
        userId = currentUser?.id as String;
      }

      final core = CoreService();
      final params = {'umkm_id': userId, 'type': 'bahan'};

      final res = await core.genericGet(ApiList.umkmGroupingData, params);
      List<UmkmDocBahanHalal> bahanList = [];
      res.data.forEach((doc) {
        doc['data'].forEach((data) {
          final bahan = UmkmDocBahanHalal.fromJson(data);
          bahanList.add(bahan);
        });
      });
      return bahanList;
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
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final _userId = args?['id'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Bahan Halal List'),
          actions: [
            if (enableCreate)
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add Bahan',
                onPressed: () => _navigateToCreate(context),
              )
          ],
        ),
        body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: _getBahanList(context, _userId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<UmkmDocBahanHalal> bahanList = snapshot.data;
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: bahanList.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final bahan = bahanList[index];
                          return InkWell(
                            onTap: () => _openDetailModal(
                                context: context, bahan: bahan),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(bahan.id,
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
                                              Text(bahan.docId)
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

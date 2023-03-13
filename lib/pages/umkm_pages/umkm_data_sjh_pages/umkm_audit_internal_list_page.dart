import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmAuditInternalListPage extends StatelessWidget {
  const UmkmAuditInternalListPage({Key? key, this.enableCreate = true})
      : super(key: key);

  final bool enableCreate;

  void _navigateToCreate(BuildContext context) {
    Navigator.of(context).pushNamed('/umkm/data-sjh/audit-internal/create');
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
    required UmkmAuditInternal audit,
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
                      child: Text(audit.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    SizedBox(height: 10),
                    _getDetailRow('Document ID', audit.docId),
                    Divider(),
                    _getDetailRow('Auditee', audit.data.auditee),
                    Divider(),
                    _getDetailRow('Auditor', audit.data.namaAuditor),
                    Divider(),
                    _getDetailRow('Bagian Diaudit', audit.data.bagianDiaudit),
                    Divider(),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[100],
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: audit.data.data.length + 1,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              if (index == 0)
                                return SizedBox(height: 20);
                              else if (index == audit.data.data.length + 1)
                                return SizedBox(height: 20);

                              final answer = audit.data.data[index - 1];
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Soal ' + answer.id),
                                    Text(answer.jawaban ? 'Ya' : 'Tidak')
                                  ],
                                ),
                              );
                            },
                          ),
                        ))
                  ],
                ),
              ));
        });
  }

  Future<List<UmkmAuditInternal>?> _getAuditInternalList(
      BuildContext context) async {
    final logger = Logger();
    try {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
      String? userId;

      if (args != null) {
        userId = args['id'];
      } else {
        final currentUser = await getUserData();
        userId = currentUser?.id;
      }

      final core = CoreService();
      final params = {'umkm_id': userId, 'type': 'audit'};
      final res = await core.genericGet(ApiList.umkmGroupingData, params);
      List<UmkmAuditInternal> auditList = [];
      res.data.forEach((doc) {
        doc['data'].forEach((data) {
          final audit = UmkmAuditInternal.fromJSON(data);
          auditList.add(audit);
        });
      });
      return auditList;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Audit Internal List'),
        actions: [
          if (enableCreate)
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add Audit Internal',
              onPressed: () => _navigateToCreate(context),
            )
        ],
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: _getAuditInternalList(context),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<UmkmAuditInternal> auditList = snapshot.data;
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: auditList.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final audit = auditList[index];
                        return InkWell(
                          onTap: () =>
                              _openDetailModal(context: context, audit: audit),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(audit.id,
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
                                          Icon(Icons.calendar_month,
                                              color: Colors.grey[600],
                                              size: 12),
                                          SizedBox(width: 5),
                                          Text(defaultDateFormat
                                              .format(audit.data.createdAt))
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Wrap(
                                          direction: Axis.horizontal,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Icon(Icons.file_copy,
                                                color: Colors.grey[600],
                                                size: 12),
                                            SizedBox(width: 5),
                                            Text(audit.docId)
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
      ),
    );
  }
}

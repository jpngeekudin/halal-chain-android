import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/http_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/models/simulasi_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class UmkmSimulasi2Page extends StatefulWidget {
  const UmkmSimulasi2Page({ Key? key }) : super(key: key);

  @override
  State<UmkmSimulasi2Page> createState() => _UmkmSimulasi2PageState();
}

class _UmkmSimulasi2PageState extends State<UmkmSimulasi2Page> {
  Future<List<SimulasiLog>> _getSimulasi({ required BuildContext context, }) async {
    final logger = Logger();
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.simulasiGet, params);
      if (res.data == null) throw('Data not found');
      final simulasiList = res.data['log'].map<SimulasiLog>((json) => SimulasiLog.fromJSON(json)).toList();
      return simulasiList;
    }

    catch(err, trace) {
      logger.e(err);
      logger.e(trace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['data'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw(message);
    }
  }

  Future<String> _getSaran() async {
    try {
      final user = await getUserUmkmData();
      final core = CoreService();
      final params = { 'creator_id': user?.id };
      final res = await core.genericGet(ApiList.simulasiSaran, params);
      return res.data;
    }

    catch(err) {
      handleHttpError(context: context, err: err);
      if (err is DioError) throw(err.response?.data['data']);
      throw(err.toString());
    }
  }

  Widget _getStatus(String status) {
    return 
      Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(status == 'failed'
            ? Icons.remove_circle_outline
            : Icons.check_circle_outline,
            color: status == 'failed'
            ? Colors.red : Colors.green,
            size: 12,
          ),
          SizedBox(width: 5),
          Text(status)
        ],
      );
  }

  Widget _getSimulasiCard(SimulasiLog simulasi) {
    final dateFormat = DateFormat('yyyy/MM/dd hh:mm:ss');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateFormat.format(simulasi.createdAt), style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
          )),
          SizedBox(height: 5),
          _getStatus(simulasi.status)
        ],
      ),
    );
  }

  void _showModalSimulasi({
    required BuildContext context,
    required SimulasiLog simulasi
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: ModalBottomSheetShape,
      builder: (context) {
        return getModalBottomSheetWrapper(
          context: context,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(defaultDateFormat.format(simulasi.createdAt), style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )),
                  SizedBox(height: 5),
                  _getStatus(simulasi.status),
                  SizedBox(height: 20),
                  Text('List Bahan', style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: simulasi.data.length,
                    separatorBuilder:(context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final bahan = simulasi.data[index];
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Text(bahan.name),
                            SizedBox(height: 5),
                            Wrap(
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              alignment: WrapAlignment.center,
                              children: [
                                Icon(
                                  bahan.status ? Icons.check_circle : Icons.remove_circle,
                                  color: bahan.status ? Colors.green : Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 5),
                                Text(bahan.detail, style: TextStyle(
                                  color: Colors.grey[600]
                                )),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        );
      }
    );
  }

  Future _simulasi(BuildContext context) async {
    final logger = Logger();
    try {
      final core = CoreService();
      final user = await getUserUmkmData();
      final params = { 'creator_id': user!.id };
      final res = await core.genericPost(ApiList.simulasiCreate, params, {});
      // final simulasiResultList = res.data.map<SimulasiLogData>((json) => SimulasiLogData.fromJSON(json)).toList();
      final snackBar = SnackBar(content: Text('Simulasi berhasil ditambahkan!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }

    catch(err, trace) {
      logger.e(err);
      logger.e(trace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulasi SJH'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Saran Simulasi', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
                SizedBox(height: 20),
                FutureBuilder(
                  future: _getSaran(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data, style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ));
                    }

                    else if (snapshot.hasError) {
                      return Container(
                        alignment: Alignment.center,
                        height: 100,
                        child: Text(snapshot.error.toString(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]
                        )),
                      );
                    }

                    else return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  }
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Log Simulasi', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                    TextButton(
                      child: Text('Simulasi'),
                      onPressed: () => _simulasi(context),
                    )
                  ],
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: _getSimulasi(context: context),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final List<SimulasiLog> simulasiList = snapshot.data;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...simulasiList.map((simulasi) {
                            return InkWell(
                              onTap: () => _showModalSimulasi(context: context, simulasi: simulasi),
                              child: _getSimulasiCard(simulasi),
                            );
                          })
                        ],
                      );
                    }

                    else if (snapshot.hasError) {
                      return Container(
                        alignment: Alignment.center,
                        height: 400,
                        child: Text(snapshot.error.toString(), style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]
                        )),
                      );
                    }

                    else return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              ],
            ),
          ),
        )
      )
    );
  }
}
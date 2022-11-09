import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class AuditorReviewUserPage extends StatelessWidget {
  const AuditorReviewUserPage({ Key? key }) : super(key: key);

  Future<List<UserUmkmData>> _getUserList({
    required BuildContext context,
  }) async {
    final logger = Logger();

    try {
      final core = CoreService();
      final params = { 'lph_id': 'all' };
      final res = await core.genericGet(ApiList.getUserUmkmAll, params);
      final List<UserUmkmData> umkmList = res.data.map<UserUmkmData>((json) => UserUmkmData.fromJSON(json)).toList();
      return umkmList;
    }

    catch(err, trace) {
      logger.e(err);
      logger.e(trace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['data'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: FutureBuilder(
              future: _getUserList(context: context),
              builder:(context, AsyncSnapshot snapshot) {
                final placeholderStyle = TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400]
                );

                if (snapshot.hasData) {
                  final List<UserUmkmData> umkmList = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...umkmList.map((umkm) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/auditor/review/list',
                              arguments: { 'id': umkm.id }
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Wrap(
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(umkm.username, style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                                SizedBox(height: 10),
                                Text(umkm.productName, style: TextStyle(
                                  color: Colors.grey[600]
                                )),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  );
                }

                else if (snapshot.hasError) return Container(
                  height: 400,
                  alignment: Alignment.center,
                  child: Text(snapshot.error.toString(), style: placeholderStyle),
                );

                else return Container(
                  height: 400,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
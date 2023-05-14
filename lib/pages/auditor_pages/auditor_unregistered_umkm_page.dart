import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/models/umkm_not_registered_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class AuditorUnregisteredUmkmPage extends StatefulWidget {
  const AuditorUnregisteredUmkmPage({Key? key}) : super(key: key);

  @override
  State<AuditorUnregisteredUmkmPage> createState() =>
      _AuditorUnregisteredUmkmPageState();
}

class _AuditorUnregisteredUmkmPageState
    extends State<AuditorUnregisteredUmkmPage> {
  @override
  Widget build(BuildContext context) {
    Future<List<UmkmNotRegistered>> _getUmkmList() async {
      try {
        final core = CoreService();
        final params = {'lph_id': 'all'};
        final response =
            await core.genericGet(ApiList.coreGetUmkmNotRegistered, params);
        final umkmList = response.data
            .map<UmkmNotRegistered>((d) => UmkmNotRegistered.fromJson(d))
            .toList();
        return umkmList;
      } catch (err, traceback) {
        final logger = Logger();
        logger.e(traceback);
        String message = 'Terjadi kesalahan';
        if (err is DioError)
          message = err.response?.data?['message'] ?? message;
        final snackBar = SnackBar(content: Text(message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        rethrow;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Unregistered UMKM'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: FutureBuilder(
                    future: _getUmkmList(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<UmkmNotRegistered> umkmList = snapshot.data;
                        return ListView(
                          shrinkWrap: true,
                          children: umkmList.map((umkm) {
                            return ListTile(
                                title: Text(
                                  '@' + umkm.username,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  umkm.companyName,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey[600]),
                                ));
                          }).toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          height: 400,
                          alignment: Alignment.center,
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        return Container(
                          height: 400,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      }
                    }))),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/models/umkm_registrator_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class AuditorRegistratorListPage extends StatefulWidget {
  const AuditorRegistratorListPage({ Key? key }) : super(key: key);

  @override
  State<AuditorRegistratorListPage> createState() => _AuditorRegistratorListPageState();
}

class _AuditorRegistratorListPageState extends State<AuditorRegistratorListPage> {

  List<UmkmRegistrator> _listRegistrator = [];

  Future _getRegistratorList() async {
    try {
      final core = CoreService();
      final response = await core.genericGet(ApiList.coreGetUmkmRegistered);
      setState(() {
        _listRegistrator = response.data
          .map<UmkmRegistrator>((d) => UmkmRegistrator.fromJson(d))
          .toList();
      });
    }

    catch(err) {
      final logger = Logger();
      logger.e(err);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    _getRegistratorList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrator List'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              children: [
                ..._listRegistrator.map((reg) {
                  return ListTile(
                    title: Text('@' + reg.username, style: TextStyle(
                      fontWeight: FontWeight.bold
                    )),
                    subtitle: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (reg.statusCheckByBpjph) ...[
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          SizedBox(width: 5),
                          Text('Checked', style: TextStyle(
                            fontSize: 10
                          ))
                        ]
                        else ...[
                          Icon(Icons.watch_later_outlined, color: Colors.grey[600]),
                          SizedBox(width: 5),
                          Text('Not Checked', style: TextStyle(
                            fontSize: 10
                          ))
                        ]
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_horiz_outlined),
                      itemBuilder: (context) => [
                        if (!reg.statusCheckByBpjph) PopupMenuItem(
                          child: Text('Check SJH'),
                          value: 'check-sjh'
                        ),
                        if (reg.statusCheckByBpjph) PopupMenuItem(
                          child: Text('Appoint LPH'),
                          value: 'appoint-lph'
                        )
                      ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'check-sjh':
                            Navigator.of(context).pushNamed('/auditor/check-sjh', arguments: { 'id': reg.id });
                            break;
                          case 'appoint-lph':
                            Navigator.of(context).pushNamed('/auditor/appoint-lph', arguments: { 'id': reg.id });
                            break;
                        }
                      },
                    ),
                    // onTap: !reg.statusCheckByBpjph
                    //   ? () {
                    //     Navigator.of(context).pushNamed('/auditor/check-sjh', arguments: { 'id': reg.id });
                    //   } : null,
                  );
                })
              ],
            )
          ),
        ),
      ),
    );
  }
}
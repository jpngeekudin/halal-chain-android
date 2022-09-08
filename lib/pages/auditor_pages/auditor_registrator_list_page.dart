import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/models/umkm_registrator_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class AuditorRegistratorListPage extends StatefulWidget {
  const AuditorRegistratorListPage({ Key? key }) : super(key: key);

  @override
  State<AuditorRegistratorListPage> createState() => _AuditorRegistratorListPageState();
}

class _AuditorRegistratorListPageState extends State<AuditorRegistratorListPage> {

  List<UmkmRegistrator> _listRegistrator = [];
  UserAuditorType? _auditorType;

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

    catch(err, trace) {
      final logger = Logger();
      logger.e(trace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _getItemChecked(UmkmRegistrator reg) {
    String byLabel = '';
    if (_auditorType == UserAuditorType.bpjph) byLabel = ' by BPJPH';
    else if (_auditorType == UserAuditorType.lph) byLabel = ' by LPH';
    else if (_auditorType == UserAuditorType.mui) byLabel = ' by MUI';

    final checkedWidget = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 16),
        SizedBox(width: 5),
        Text('Checked' + byLabel, style: TextStyle(
          fontSize: 10
        ))
      ],
    );

    final uncheckedWidget = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.watch_later_outlined, color: Colors.grey[600]),
        SizedBox(width: 5),
        Text('Not Checked' + byLabel, style: TextStyle(
          fontSize: 10
        ))
      ],
    );

    if (_auditorType == UserAuditorType.bpjph) {
      if (reg.statusCheckByBpjph) return checkedWidget;
      else return uncheckedWidget;
    }

    else if (_auditorType == UserAuditorType.lph) {
      if (reg.statusLphCheckField) return checkedWidget;
      else return uncheckedWidget;
    }

    else if (_auditorType == UserAuditorType.mui) {
      if (reg.statusCheckedMui) return checkedWidget;
      else return uncheckedWidget;
    }

    else return Container();
  }

  Future _getAuditorType() async {
    final auditor = await getUserAuditorData();
    setState(() => _auditorType = auditor!.type);
  }

  final popupItemStyle = TextStyle(
    fontSize: 12
  );

  @override
  void initState() {
    _getAuditorType();
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
                    subtitle: _getItemChecked(reg),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_horiz_outlined),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Check SJH by BPJPH', style: popupItemStyle),
                          value: 'check-sjh-bpjph'
                        ),
                        PopupMenuItem(
                          child: Text('Appoint LPH', style: popupItemStyle),
                          value: 'appoint-lph'
                        ),
                        PopupMenuItem(
                          child: Text('Check SJH by LPH', style: popupItemStyle),
                          value: 'check-sjh-lph'
                        ),
                        PopupMenuItem(
                          child: Text('Review Tempat Bisnis', style: popupItemStyle),
                          value: 'review-place'
                        ),
                        PopupMenuItem(
                          child: Text('Check SJH by MUI', style: popupItemStyle),
                          value: 'check-sjh-mui'
                        ),
                        PopupMenuItem(
                          child: Text('Upload Certificate', style: popupItemStyle),
                          value: 'upload-cert'
                        ),
                      ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'check-sjh-bpjph':
                            Navigator.of(context).pushNamed('/auditor/check-sjh',
                              arguments: { 'id': reg.id, 'checkType': 'check-bpjph' }
                            );
                            break;
                          case 'appoint-lph':
                            Navigator.of(context).pushNamed('/auditor/appoint-lph', arguments: { 'id': reg.id });
                            break;
                          case 'check-sjh-lph':
                            Navigator.of(context).pushNamed('/auditor/check-sjh',
                              arguments: { 'id': reg.id, 'checkType': 'check-lph' }
                            );
                            break;
                          case 'review-place':
                            Navigator.of(context).pushNamed('/auditor/check-sjh',
                              arguments: { 'id': reg.id, 'checkType': 'review-place' }
                            );
                            break;
                          case 'check-sjh-mui':
                            Navigator.of(context).pushNamed('/auditor/check-sjh-mui',
                              arguments: { 'id': reg.id }
                            );
                            break;
                          case 'upload-cert':
                            Navigator.of(context).pushNamed('/auditor/upload-cert',
                              arguments: { 'id': reg.id }
                            );
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
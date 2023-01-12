import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/http_helper.dart';
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
      final currentUser = await getUserAuditorData();
      final core = CoreService();
      final lphId = currentUser?.type == UserAuditorType.bpjph ? 'all' : currentUser?.id;
      final params = { 'lph_id': lphId };
      final response = await core.genericGet(ApiList.coreGetUmkmRegistered, params);
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
        Icon(Icons.watch_later_outlined, color: Colors.grey[600], size: 16),
        SizedBox(width: 5),
        Text('Not Checked' + byLabel, style: TextStyle(
          fontSize: 10
        ))
      ],
    );

    if (_auditorType == UserAuditorType.bpjph) {
      if (reg.statusCheckByBpjph && reg.lphId.isNotEmpty && reg.certificateStatus) return checkedWidget;
      else return uncheckedWidget;
    }

    else if (_auditorType == UserAuditorType.lph) {
      if (reg.statusCheckByLph && reg.statusLphCheckField == 'approved') return checkedWidget;
      else return uncheckedWidget;
    }

    else if (_auditorType == UserAuditorType.mui) {
      if (reg.statusCheckedMui && reg.fatwaStatus) return checkedWidget;
      else return uncheckedWidget;
    }

    else return Container();
  }

  PopupMenuItem<String> _getPopupMenuItem(String value, String label, [bool done = false]) {
    return PopupMenuItem(
      child: Wrap(
        children: [
          done
            ? Icon(Icons.check_circle_outline, size: 16, color: Colors.green)
            : Icon(Icons.watch_later_outlined, size: 16),
          SizedBox(width: 5),
          Text(label, style: popupItemStyle),
        ],
      ),
      value: value
    );
  }

  Future _getAuditorType() async {
    final auditor = await getUserAuditorData();
    setState(() => _auditorType = auditor!.type);
  }

  Future _generateCert(UmkmRegistrator umkm) async {
    try {
      final core = CoreService();
      final params = { 'umkm_id': umkm.umkmId };
      final response = await core.genericPost(ApiList.generateCertificate, params, null);
      const snackBar = SnackBar(content: Text('Success generating certificate!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      handleHttpError(context: context, err: err);
    }
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
                  late String assigned;
                  if (reg.lphId.isNotEmpty) assigned = 'Assigned to ' + reg.lphId;
                  else assigned = 'Not assigned to any LPH';

                  return ListTile(
                    title: Text('@' + reg.username, style: TextStyle(
                      fontWeight: FontWeight.bold
                    )),
                    subtitle: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _getItemChecked(reg),
                        SizedBox(width: 10),
                        Text(assigned, style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600]
                        )),
                      ]
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_horiz_outlined),
                      itemBuilder: (context) => [

                        // if user bpjph
                        if (_auditorType == UserAuditorType.bpjph)
                          ...[
                            _getPopupMenuItem('check-sjh-bpjph', 'Check SJH by BPJPH', reg.statusCheckByBpjph),
                            _getPopupMenuItem('appoint-lph', 'Appoint LPH', reg.lphId.isNotEmpty),
                            // _getPopupMenuItem('upload-cert', 'Upload Certificate', reg.certificateStatus),
                            _getPopupMenuItem('generate-cert', 'Generate Certificate', reg.certificateStatus),
                          ]

                        // if user lph
                        else if (_auditorType == UserAuditorType.lph)
                          ...[
                            _getPopupMenuItem('check-sjh-lph', 'Check SJH by LPH',  reg.statusCheckByLph),
                            _getPopupMenuItem('review-place', 'Review Tempat Bisnis', reg.statusLphCheckField == 'approved'),
                          ]

                        // if user mui
                        else if (_auditorType == UserAuditorType.mui)
                          ...[
                            _getPopupMenuItem('check-sjh-mui', 'Check SJH by MUI', reg.statusCheckedMui),
                            _getPopupMenuItem('upload-fatwa', 'Upload Fatwa', reg.fatwaStatus),
                          ],
                      ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'check-sjh-bpjph':
                            Navigator.of(context).pushNamed('/auditor/check-sjh',
                              arguments: { 'id': reg.umkmId, 'checkType': 'check-bpjph' }
                            );
                            break;
                          case 'appoint-lph':
                            Navigator.of(context).pushNamed('/auditor/appoint-lph', arguments: { 'id': reg.umkmId });
                            break;
                          case 'check-sjh-lph':
                            Navigator.of(context).pushNamed('/auditor/check-sjh',
                              arguments: { 'id': reg.umkmId, 'checkType': 'check-lph' }
                            );
                            break;
                          case 'review-place':
                            Navigator.of(context).pushNamed('/auditor/check-sjh',
                              arguments: { 'id': reg.umkmId, 'checkType': 'review-place' }
                            );
                            break;
                          case 'check-sjh-mui':
                            Navigator.of(context).pushNamed('/auditor/check-sjh-mui',
                              arguments: { 'id': reg.umkmId }
                            );
                            break;
                          case 'upload-cert':
                            Navigator.of(context).pushNamed('/auditor/upload-cert',
                              arguments: { 'id': reg.umkmId }
                            );
                            break;
                          case 'upload-fatwa':
                            Navigator.of(context).pushNamed('/auditor/upload-fatwa',
                              arguments: { 'id': reg.umkmId }
                            );
                            break;
                          case 'generate-cert':
                            _generateCert(reg);
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
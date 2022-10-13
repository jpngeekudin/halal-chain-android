import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/http_helper.dart';
import 'package:halal_chain/helpers/typography_helper.dart';
import 'package:halal_chain/models/qr_model.dart';
import 'package:halal_chain/models/umkm_mui_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class AuditorCheckSjhMuiPage extends StatefulWidget {
  const AuditorCheckSjhMuiPage({Key? key}) : super(key: key);

  @override
  State<AuditorCheckSjhMuiPage> createState() => _AuditorCheckSjhMuiPageState();
}

class _AuditorCheckSjhMuiPageState extends State<AuditorCheckSjhMuiPage> {

  QrDetailCore? _muiData;
  String _statusModel = '';
  final _descriptionController = TextEditingController();

  Future _getMuiData() async {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = args['id'];

    try {
      final core = CoreService();
      final params = { 'umkm_id': id };
      final response = await core.genericGet(ApiList.coreMuiGetData, params);
      setState(() {
        _muiData = QrDetailCore.fromJson(response.data);
      });
    }

    catch(err, trace) {
      final logger = Logger();
      logger.e(trace);
      handleHttpError(context: context, err: err);
    }
  }

  void _downloadSjhDoc() async {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final umkmId = args['id'];

    try {
      Directory directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) directory = (await getExternalStorageDirectory())!;

      Logger logger = Logger();
      String url = ApiList.generateDownloadDoc + '?umkm_id=$umkmId';
      logger.i(url);
      // final taskId = await FlutterDownloader.enqueue(
      //   url: url,
      //   savedDir: directory.path,
      //   showNotification: true,
      //   openFileFromNotification: true,
      // );
      final dio = Dio();
      final res = await dio.get(url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500
        )
      );

      String contentDisposition = res.headers.value('content-disposition')!;
      String filename = contentDisposition.substring(22, contentDisposition.length-1);
      String fullPath = directory.path + '/$filename';

      final file = await File(fullPath).create();
      file.writeAsBytesSync(res.data);

      // var raf = file.openSync(mode: FileMode.write);
      // raf.writeFromSync(res.data);
      // await raf.close();

      final snackBar = SnackBar(content: Text('Success downloading file at $fullPath'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err, trace) {
      final logger = Logger();
      logger.e(err);
      logger.e(trace);
    }
  }
  
  Widget _getSjhDataTile(String label, dynamic value) {
    return ListTile(
      title: Text(label, style: TextStyle(
        fontSize: 12,
      )),
      trailing: Text(value.toString(), style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold
      )),
      contentPadding: EdgeInsets.zero
    );
  }

  Future _submit() async {
    if (_statusModel.isEmpty || _descriptionController.text.isEmpty) {
      const snackBar = SnackBar(content: Text('Harap isi seluruh field yang dibutuhkan'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final umkmId = args['id'];

      final user = await getUserData();
      final core = CoreService();
      final params = {
        'umkm_id': umkmId,
        'mui_id': user!.id,
        'status': _statusModel,
        'description': _descriptionController.text
      };
      final response = await core.genericPost(ApiList.coreMuiCheckingData, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    catch(err) {
      handleHttpError(context: context, err: err);
    }
  }

  @override
  void didChangeDependencies() {
    _getMuiData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check SJH Data'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getHeader(
                  context: context,
                  text: 'Data SJH'
                ),
                if (_muiData == null) CircularProgressIndicator()
                else ...[
                  _getSjhDataTile('ID', _muiData?.id),
                  _getSjhDataTile('Status Registrasi', _muiData?.registration.status),
                  _getSjhDataTile('Checked by BPJPH', _muiData?.bpjphChecked.status),
                  _getSjhDataTile('BPJPH Note', _muiData?.bpjphChecked.desc),
                  _getSjhDataTile('Selected LPH', _muiData?.lphAppointment.lphId),
                  _getSjhDataTile('Checked by LPH', _muiData?.lphChecked.reviewStatus),
                  _getSjhDataTile('LPH Note', _muiData?.lphChecked.desc),
                  _getSjhDataTile('LPH Location Survey', _muiData?.lphChecked.surveyLocation),
                ],
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _downloadSjhDoc(),
                      child: Text('Download Doc SJH')
                    ),
                  ],
                ),
                SizedBox(height: 30),

                getHeader(
                  context: context,
                  text: 'Review'
                ),
                getInputWrapper(
                  label: 'Approve',
                  input: DropdownButtonFormField(
                    decoration: getInputDecoration(label: 'Approve'),
                    style: inputTextStyle,
                    items: [
                      DropdownMenuItem(
                        value: 'Approved',
                        child: Text('Approved', style: TextStyle(
                          color: Colors.black
                        )),
                      ),
                      DropdownMenuItem(
                        value: 'Decline',
                        child: Text('Decline', style: TextStyle(
                          color: Colors.black
                        ))
                      )
                    ],
                    onChanged: (String? value) {
                      setState(() => _statusModel = value!);
                    },
                  )
                ),
                getInputWrapper(
                  label: 'Deskripsi',
                  input: TextFormField(
                    controller: _descriptionController,
                    decoration: getInputDecoration(label: 'Deskripsi'),
                    style: inputTextStyle,
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text('Submit'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
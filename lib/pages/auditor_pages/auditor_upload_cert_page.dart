import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/http_helper.dart';
import 'package:halal_chain/helpers/typography_helper.dart';
import 'package:halal_chain/services/core_service.dart';

class AuditorUploadCertPage extends StatefulWidget {
  const AuditorUploadCertPage({Key? key, this.type = 'bpjph'})
      : super(key: key);
  final String type;

  @override
  State<AuditorUploadCertPage> createState() => _AuditorUploadCertPageState();
}

class _AuditorUploadCertPageState extends State<AuditorUploadCertPage> {
  final _expireController = TextEditingController();
  DateTime? _expireModel;
  File? _certificateModel;
  String _statusModel =
      'Successful'; // 'Canceled' || 'Returned' || 'Successful' || 'Rejected';

  final _statusOpts = ['Canceled', 'Returned', 'Successful', 'Rejected'];

  Future _submit() async {
    try {
      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final umkmId = args['id'];

      final core = CoreService();
      final paramsImage = FormData.fromMap({
        'image': await MultipartFile.fromFile(_certificateModel!.path,
            filename: _certificateModel!.path.split('/').last)
      });

      final uploadImage =
          await core.genericPost(ApiList.imageUpload, null, paramsImage);
      final params = {
        'umkm_id': umkmId,
        'cert_id': uploadImage.data,
        'expire': _expireModel?.millisecondsSinceEpoch,
        'status': _statusModel
      };

      final url = widget.type == 'bpjph'
          ? ApiList.coreBpjphInsertCert
          : ApiList.coreMuiInsertFatwa;
      final response = await core.genericPost(url, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (err) {
      handleHttpError(context: context, err: err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.type == 'bpjph' ? 'Upload Certificate' : 'Upload Fatwa')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getInputWrapper(
                  label: 'Expire',
                  input: getInputDate(
                      label: 'Expire',
                      controller: _expireController,
                      context: context,
                      onChanged: (pickedDate) {
                        setState(() => _expireModel = pickedDate);
                      }),
                ),
                getInputWrapper(
                    label: widget.type == 'bpjph'
                        ? 'Certificate Image'
                        : 'Fatwa Image',
                    input: getInputFile(
                        model: _certificateModel,
                        onChanged: (value) {
                          setState(() => _certificateModel = value);
                        },
                        context: context)),
                getInputWrapper(
                    label: 'Status',
                    input: DropdownButtonFormField(
                      decoration: getInputDecoration(label: 'Status'),
                      style: inputTextStyle,
                      items: [
                        ..._statusOpts.map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                      value: _statusModel,
                      onChanged: (String? value) {
                        setState(() => _statusModel = value!);
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: _submit, child: Text('Submit'))
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

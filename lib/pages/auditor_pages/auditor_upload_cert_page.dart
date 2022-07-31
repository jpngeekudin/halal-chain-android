import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/http_helper.dart';
import 'package:halal_chain/helpers/typography_helper.dart';
import 'package:halal_chain/services/core_service.dart';

class AuditorUploadCertPage extends StatefulWidget {
  const AuditorUploadCertPage({Key? key}) : super(key: key);

  @override
  State<AuditorUploadCertPage> createState() => _AuditorUploadCertPageState();
}

class _AuditorUploadCertPageState extends State<AuditorUploadCertPage> {

  File? _certificateModel;

  Future _submit() async {
    try {
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final umkmId = args['id'];

      final core = CoreService();
      final paramsImage = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          _certificateModel!.path,
          filename: _certificateModel!.path.split('/').last
        )
      });
      
      final uploadImage = await core.genericPost(ApiList.imageUpload, null, paramsImage);
      final params = {
        'umkm_id': umkmId,
        'cert_id': uploadImage.data
      };
      final response = await core.genericPost(ApiList.coreBpjphInsertCert, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      handleHttpError(context: context, err: err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Cert')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getInputWrapper(
                  label: 'Certificate Image',
                  input: getInputFile(
                    model: _certificateModel,
                    onChanged: (value) {
                      setState(() => _certificateModel = value);
                    },
                    context: context
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text('Submit')
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
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/http_helper.dart';
import 'package:halal_chain/services/core_service.dart';

class ConsumentPelaporanPage extends StatelessWidget {
  ConsumentPelaporanPage({ Key? key }) : super(key: key);

  File? _imageModel;
  final _descriptionController = TextEditingController();
  final _umkmNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _userNameController = TextEditingController();

  Future _submit(BuildContext context) async {
    try {
      final core = CoreService();
      final paramsImage = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          _imageModel!.path,
          filename: _imageModel!.path.split('/').last
        )
      });

      final uploadImage = await core.genericPost(ApiList.imageUpload, null, paramsImage);
      final params = {
        'image': uploadImage.data,
        'description': _descriptionController.text,
        'umkm_name': _umkmNameController.text,
        'address': _addressController.text,
        'user_name': _userNameController.text
      };

      final response = await core.genericPost(ApiList.pelaporanCreate, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses melaporkan produk!'));
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
        title: Text('Pelaporan')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getInputWrapper(
                  label: 'UMKM Name',
                  input: TextField(
                    controller: _umkmNameController,
                    decoration: getInputDecoration(label: 'UMKM Name'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Description',
                  input: TextField(
                    controller: _descriptionController,
                    decoration: getInputDecoration(label: 'Description'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Address',
                  input: TextField(
                    controller: _addressController,
                    decoration: getInputDecoration(label: 'Address'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Username',
                  input: TextField(
                    controller: _userNameController,
                    decoration: getInputDecoration(label: 'Username'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Image',
                  input: StatefulBuilder(
                    builder: (context, setStateFile) {
                      return getInputFile(
                        model: _imageModel,
                        context: context,
                        onChanged: (image) {
                          setStateFile(() {
                            _imageModel = image;
                          });
                        },
                      );
                    }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        _submit(context);
                      },
                    ),
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
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/form_config_model.dart';

class UmkmDetailInsertPage extends StatefulWidget {
  const UmkmDetailInsertPage({ Key? key }) : super(key: key);

  @override
  State<UmkmDetailInsertPage> createState() => _UmkmDetailInsertPageState();
}

class _UmkmDetailInsertPageState extends State<UmkmDetailInsertPage> {

  final _formKey = GlobalKey<FormState>();
  final _namaKetuaController = TextEditingController();
  final _namaPenanggungjawabController = TextEditingController();
  File? _logoPerusahaanModel;
  File? _ttdKetuaModel;
  File? _ttdPenanggungjawabModel;

  // List<FormConfig> _formConfigs = [];

  void _submit() {
    final params = {
      'nama_ketua': _namaKetuaController.text,
      'nama_penanggungjawab': _namaPenanggungjawabController.text,
      'logo_perusahaan': _logoPerusahaanModel.toString(),
      'ttd_ketua': _ttdKetuaModel.toString(),
      'ttd_penanggungjawab': _ttdPenanggungjawabModel.toString()
    };

    print(params);
  }

  @override
  void initState() {
    // _formConfigs = [
    //   FormConfig(
    //     label: 'Nama Ketua',
    //     controller: _namaKetuaController,
    //     validator: validateRequired
    //   ),
    //   FormConfig(
    //     label: 'Nama Penanggungjawab',
    //     controller: _namaPenanggungjawabController,
    //     validator: validateRequired,
    //   ),
    //   FormConfig(
    //     label: 'Logo Perusahaan',
    //     type: FormConfigType.file,
    //     value: _logoPerusahaanModel,
    //     onChanged: (dynamic image) {
    //       setState(() => _logoPerusahaanModel = image);
    //     }
    //   ),
    //   FormConfig(
    //     label: 'Tanda Tangan Ketua',
    //     type: FormConfigType.file,
    //     value: _ttdKetuaModel,
    //     onChanged: (dynamic image) {
    //       setState(() => _ttdKetuaModel = image);
    //     }
    //   ),
    //   FormConfig(
    //     label: 'Tanda Tangan Penanggungjawab',
    //     type: FormConfigType.file,
    //     value: _ttdPenanggungjawabModel,
    //     onChanged: (dynamic image) {
    //       setState(() => _ttdPenanggungjawabModel = image);
    //     }
    //   )
    // ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Insert Detail UMKM')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            // child: buildFormList(
            //   configs: _formConfigs,
            //   key: _formKey,
            //   context: context,
            //   onSubmit: _submit,
            // )
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama Ketua', style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _namaKetuaController,
                          decoration: getInputDecoration(label: 'Nama Ketua'),
                          style: inputTextStyle,
                          validator: validateRequired,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama Penanggungjawab', style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _namaPenanggungjawabController,
                          decoration: getInputDecoration(label: 'Nama Penanggungjawab'),
                          style: inputTextStyle,
                          validator: validateRequired,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Logo Perusahaan', style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(height: 10,),
                        getInputFile(
                          context: context,
                          model: _logoPerusahaanModel,
                          onChanged: (file) {
                            setState(() => _logoPerusahaanModel = file);
                          }
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanda Tangan Ketua', style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(height: 10,),
                        getInputFile(
                          context: context,
                          model: _ttdKetuaModel,
                          onChanged: (file) {
                            setState(() => _ttdKetuaModel = file);
                          }
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanda Tangan Penanggungjawab', style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(height: 10,),
                        getInputFile(
                          context: context,
                          model: _ttdPenanggungjawabModel,
                          onChanged: (file) {
                            setState(() => _ttdPenanggungjawabModel = file);
                          }
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => _submit(),
                        child: Text('Submit'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
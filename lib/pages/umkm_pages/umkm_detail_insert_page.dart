import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/services/core_service.dart';

class UmkmDetailInsertPage extends StatefulWidget {
  const UmkmDetailInsertPage({ Key? key }) : super(key: key);

  @override
  State<UmkmDetailInsertPage> createState() => _UmkmDetailInsertPageState();
}

class _UmkmDetailInsertPageState extends State<UmkmDetailInsertPage> {

  final _core = CoreService();
  final _formKey = GlobalKey<FormState>();
  final _namaKetuaController = TextEditingController();
  final _namaPenanggungjawabController = TextEditingController();
  File? _logoPerusahaanModel;
  File? _ttdKetuaModel;
  File? _ttdPenanggungjawabModel;

  // List<FormConfig> _formConfigs = [];

  Future _submit() async {
    if (
      _namaKetuaController.text.isEmpty ||
      _namaPenanggungjawabController.text.isEmpty ||
      _logoPerusahaanModel == null ||
      _ttdKetuaModel == null ||
      _ttdPenanggungjawabModel == null
    ) {
      const snackBar = SnackBar(content: Text('Harap isi semua field yang dibutuhkan'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();
    final logoPerusahaanFormData = FormData.fromMap({
      'image': await MultipartFile.fromFile(_logoPerusahaanModel!.path, filename: _logoPerusahaanModel!.path.split('/').last)
    });

    final ttdKetuaFormData = FormData.fromMap({
      'image': await MultipartFile.fromFile(_ttdKetuaModel!.path, filename: _ttdKetuaModel!.path.split('/').last)
    });

    final ttdPenanggungjawabFormData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        _ttdPenanggungjawabModel!.path,
        filename: _ttdPenanggungjawabModel!.path.split('/').last
      )
    });

    final uploadLogoPerusahaan = await _core.genericPost(ApiList.imageUpload, null, logoPerusahaanFormData);
    final uploadTtdKetua = await _core.genericPost(ApiList.imageUpload, null, ttdKetuaFormData);
    final uploadTtdPenanggungjawab = await _core.genericPost(ApiList.imageUpload, null, ttdPenanggungjawabFormData);

    final params = {
      'id': document!.id,
      'nama_ketua': _namaKetuaController.text,
      'nama_penanggungjawab': _namaPenanggungjawabController.text,
      'logo_perusahaan': uploadLogoPerusahaan.data,
      'ttd_ketua': uploadTtdKetua.data,
      'ttd_penanggungjawab': uploadTtdPenanggungjawab.data
    };

    try {
      final response = await _core.createDetailUmkm(params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
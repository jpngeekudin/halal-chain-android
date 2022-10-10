import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/helpers/utils_helper.dart';
import 'package:halal_chain/models/signature_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/signature_form_widget.dart';
import 'package:logger/logger.dart';
import 'package:signature/signature.dart';

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
  final _noTelpKetuaController = TextEditingController();
  final _noKtpKetuaController = TextEditingController();
  File? _logoPerusahaanModel;
  // File? _ttdKetuaModel;
  // File? _ttdPenanggungjawabModel;

  final _ttdKetuaController = SignatureController(penStrokeWidth: 5);
  final _ttdPenanggungjawabController = SignatureController(penStrokeWidth: 5);

  UserSignature? _signatureKetuaModel;
  UserSignature? _signaturePenanggungjawabModel;

  // List<FormConfig> _formConfigs = [];
  final _bold = TextStyle(
    fontWeight: FontWeight.bold
  );

  void _openSignatureModal(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: ModalBottomSheetShape,
      builder: (context) {
        return SignatureFormWidget();
      }
    ).then((signature) {
      setState(() {
        if (type == 'ketua') _signatureKetuaModel = signature;
        else if (type == 'penanggungjawab') _signaturePenanggungjawabModel = signature;
      });
    });
  }

  Future _submit() async {
    if (
      _namaKetuaController.text.isEmpty ||
      _namaPenanggungjawabController.text.isEmpty ||
      _noTelpKetuaController.text.isEmpty ||
      _noKtpKetuaController.text.isEmpty ||
      _logoPerusahaanModel == null ||
      // _ttdKetuaModel == null ||
      // _ttdPenanggungjawabModel == null
      // _ttdKetuaController.isEmpty ||
      // _ttdPenanggungjawabController.isEmpty
      _signatureKetuaModel == null ||
      _signaturePenanggungjawabModel == null
    ) {
      const snackBar = SnackBar(content: Text('Harap isi semua field yang dibutuhkan'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();

    // final ttdKetuaBytes = await _ttdKetuaController.toPngBytes();
    // final ttdPenanggungjawabBytes = await _ttdPenanggungjawabController.toPngBytes();

    // final ttdKetuaFile = await uint8ListToFile(ttdKetuaBytes!);
    // final ttdPenanggungjawabFile = await uint8ListToFile(ttdPenanggungjawabBytes!);

    final logoPerusahaanFormData = FormData.fromMap({
      'image': await MultipartFile.fromFile(_logoPerusahaanModel!.path, filename: _logoPerusahaanModel!.path.split('/').last)
    });

    // final ttdKetuaFormData = FormData.fromMap({
    //   'image': await MultipartFile.fromFile(
    //     ttdKetuaFile.path,
    //     filename: ttdKetuaFile.path.split('/').last
    //   )
    // });

    // final ttdPenanggungjawabFormData = FormData.fromMap({
    //   'image': await MultipartFile.fromFile(
    //     ttdPenanggungjawabFile.path,
    //     filename: ttdPenanggungjawabFile.path.split('/').last
    //   )
    // });

    final uploadLogoPerusahaan = await _core.genericPost(ApiList.imageUpload, null, logoPerusahaanFormData);
    // final uploadTtdKetua = await _core.genericPost(ApiList.imageUpload, null, ttdKetuaFormData);
    // final uploadTtdPenanggungjawab = await _core.genericPost(ApiList.imageUpload, null, ttdPenanggungjawabFormData);

    // final paramsSignatureKetua = {
    //   'name': _namaKetuaController.text,
    //   'title': 'Ketua',
    //   'sign': uploadTtdKetua.data,
    //   'types': 'UMKM',
    //   'type_id': document!.id
    // };

    // final paramsSignaturePenanggungjawab = {
    //   'name': _namaPenanggungjawabController.text,
    //   'title': 'Penanggungjawab',
    //   'sign': uploadTtdPenanggungjawab.data,
    //   'types': 'UMKM',
    //   'type_id': document!.id
    // };

    try {
      // final resSignatureKetua = await _core.genericPost(ApiList.utilInputSignature, null, paramsSignatureKetua);
      // final resSignaturePenanggungjawab = await _core.genericPost(ApiList.utilInputSignature, null, paramsSignaturePenanggungjawab);

      final params = {
        'id': document!.id,
        'nama_ketua': _namaKetuaController.text,
        'no_telp_ketua': _noTelpKetuaController.text,
        'no_ktp_ketua': _noKtpKetuaController.text,
        'nama_penanggungjawab': _namaPenanggungjawabController.text,
        'logo_perusahaan': uploadLogoPerusahaan.data,
        'ttd_ketua': _signatureKetuaModel!.sign,
        'ttd_penanggungjawab': _signaturePenanggungjawabModel!.sign
      };

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
                        Text('No. Telepon Ketua', style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _noTelpKetuaController,
                          decoration: getInputDecoration(label: 'No. Telepon ketua'),
                          style: inputTextStyle,
                          validator: validateRequired,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('No. KTP Ketua', style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _noKtpKetuaController,
                          decoration: getInputDecoration(label: 'No. KTP Ketua'),
                          style: inputTextStyle,
                          validator: validateRequired,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        Text('Logo Perusahaan', style: _bold),
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
                    margin: EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text('Tanda Tangan Ketua', style: _bold),
                                SizedBox(height: 10),
                                if (_signatureKetuaModel==null) InkWell(
                                  onTap: () => _openSignatureModal('ketua'),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Icon(Icons.warning_rounded, color: Colors.grey[600]),
                                      SizedBox(width: 10),
                                      Text('Input Signature', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]
                                      ))
                                    ],
                                  ),
                                )
                                else Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.green),
                                    SizedBox(width: 10),
                                    Text('Inputted', style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text('Tanda Tangan Penanggungjawab', style: _bold),
                                SizedBox(height: 10),
                                if (_signaturePenanggungjawabModel==null) InkWell(
                                  onTap: () => _openSignatureModal('penanggungjawab'),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Icon(Icons.warning_rounded, color: Colors.grey[600]),
                                      SizedBox(width: 10),
                                      Text('Input Signature', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]
                                      ))
                                    ],
                                  ),
                                )
                                else Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.green),
                                    SizedBox(width: 10),
                                    Text('Inputted', style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   margin: EdgeInsets.only(bottom: 30),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text('Tanda Tangan Ketua', style: TextStyle(
                  //         fontWeight: FontWeight.bold
                  //       )),
                  //       SizedBox(height: 10,),
                  //       // getInputFile(
                  //       //   context: context,
                  //       //   model: _ttdKetuaModel,
                  //       //   onChanged: (file) {
                  //       //     setState(() => _ttdKetuaModel = file);
                  //       //   }
                  //       // )
                  //       getInputSignature(
                  //         controller: _ttdKetuaController,
                  //         context: context
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   width: double.infinity,
                  //   margin: EdgeInsets.only(bottom: 30),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text('Tanda Tangan Penanggungjawab', style: TextStyle(
                  //         fontWeight: FontWeight.bold
                  //       )),
                  //       SizedBox(height: 10,),
                  //       // getInputFile(
                  //       //   context: context,
                  //       //   model: _ttdPenanggungjawabModel,
                  //       //   onChanged: (file) {
                  //       //     setState(() => _ttdPenanggungjawabModel = file);
                  //       //   }
                  //       // )
                  //       getInputSignature(
                  //         controller: _ttdPenanggungjawabController,
                  //         context: context
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
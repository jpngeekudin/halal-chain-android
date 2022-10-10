import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/helpers/typography_helper.dart';
import 'package:halal_chain/helpers/utils_helper.dart';
import 'package:halal_chain/models/signature_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';
import 'package:signature/signature.dart';

class SignatureFormWidget extends StatefulWidget {
  const SignatureFormWidget({Key? key}) : super(key: key);

  @override
  State<SignatureFormWidget> createState() => _SignatureFormWidgetState();
}

class _SignatureFormWidgetState extends State<SignatureFormWidget> {

  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _signatureController = SignatureController(penStrokeWidth: 5);
  bool _loading = false;

  Future _submit() async {
    try {
      setState(() => _loading = true);
      final core = CoreService();
      final user = await getUserData();
      
      final signatureBytes = await _signatureController.toPngBytes();
      final signatureFile = await uint8ListToFile(signatureBytes!);
      final imageParams = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          signatureFile.path,
          filename: signatureFile.path.split('/').last
        ),
      });

      final resImage = await core.genericPost(ApiList.imageUpload, null, imageParams);
      final params = {
        'name': _nameController.text,
        'title': _titleController.text,
        'sign': resImage.data,
        'types': user!.role,
        'type_id': user.id
      };

      final resSignature = await core.genericPost(ApiList.utilInputSignature, null, params);
      final signature = UserSignature(
        name: _nameController.text,
        title: _titleController.text,
        sign: resImage.data,
        types: user.role,
        typeId: user.id
      );
      const snackBar = SnackBar(content: Text('Success uploading signature'));
      Navigator.of(context).pop(signature);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err, trace) {
      final logger = Logger();
      logger.e(err);
      logger.e(trace);
      
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getModalBottomSheetWrapper(
      context: context,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              getHeader(context: context, text: 'Input Signature'),
              getInputWrapper(
                label: 'Name',
                input: TextField(
                  controller: _nameController,
                  decoration: getInputDecoration(label: 'Name'),
                  style: inputTextStyle
                )
              ),
              getInputWrapper(
                label: 'Title',
                input: TextField(
                  controller: _titleController,
                  decoration: getInputDecoration(label: 'Title'),
                  style: inputTextStyle
                )
              ),
              getInputWrapper(
                label: 'Signature',
                input: getInputSignature(
                  controller: _signatureController,
                  context: context
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _loading ? null : () => _submit(),
                    child: _loading
                      ? SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      ) : Text('Submit')
                  ),
                ],
              )
            ],
          )
        ),
      )
    );
  }
}
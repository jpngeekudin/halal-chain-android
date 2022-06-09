import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/form_config_model.dart';
import 'package:halal_chain/services/main_service.dart';

class RegisterAuditorPage extends StatefulWidget {
  const RegisterAuditorPage({ Key? key }) : super(key: key);

  @override
  State<RegisterAuditorPage> createState() => _RegisterAuditorPageState();
}

class _RegisterAuditorPageState extends State<RegisterAuditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _noKtpController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _religionModel;
  final _typeController = TextEditingController();
  final _addressController = TextEditingController();
  final _institutionController = TextEditingController();
  final _competenceController = TextEditingController();
  final _experienceController = TextEditingController();
  final _certCompetenceController = TextEditingController();
  final _expiredCertController = TextEditingController();
  DateTime? _expiredCertModel;
  final _auditorExperienceController = TextEditingController();

  void _register() async {
    final formIsValid = _formKey.currentState!.validate();
    if (!formIsValid) return;

    try {
      final response = await registerAuditor({
        'no_ktp': _noKtpController.text,
        'name': _nameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'religion': _religionModel,
        'type': _typeController.text,
        'address': _addressController.text,
        'institution': _institutionController.text,
        'competence': _competenceController.text,
        'experience': _experienceController.text,
        'cert_competence': _certCompetenceController.text,
        'experied_cert': _expiredCertModel!.millisecondsSinceEpoch,
        'auditor_experience': _auditorExperienceController.text,
      });
      
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text('Sukses membuat akun!'));
        }
      );
    }

    catch(err) {
      print(err);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(content: Text(message))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formConfigs = [
      FormConfig(
        label: 'No. KTP',
        controller: _noKtpController,
        validator: validateRequired
      ),
      FormConfig(
        label: 'Name',
        controller: _nameController,
        validator: validateRequired
      ),
      FormConfig(
        label: 'Username',
        controller: _usernameController,
        validator: validateRequired
      ),
      FormConfig(
        label: 'Password',
        type: FormConfigType.password,
        controller: _passwordController,
        validator: validateRequired
      ),
      FormConfig(
        label: 'Religion',
        type: FormConfigType.select,
        onChanged: (value) => _religionModel = value,
        options: [
          FormConfigOption('islam', 'Islam'),
          FormConfigOption('protestan', 'Protestan'),
          FormConfigOption('katolik', 'Katolik'),
          FormConfigOption('hindu', 'Hindu'),
          FormConfigOption('buddha', 'Buddha'),
          FormConfigOption('khonghucu', 'Khonghucu'),
        ]
      ),
      FormConfig(
        label: 'Type',
        controller: _typeController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Address',
        controller: _addressController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Institution',
        controller: _institutionController,
        validator: validateRequired
      ),
      FormConfig(
        label: 'Competence',
        controller: _competenceController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Experience',
        controller: _experienceController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Cert Competence',
        controller: _certCompetenceController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Expired Cert',
        type: FormConfigType.date,
        controller: _expiredCertController,
        onChanged: (value) => _expiredCertModel = value,
      ),
      FormConfig(
        label: 'Auditor Experience',
        controller: _auditorExperienceController,
        validator: validateRequired,
      )
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Daftar Auditor')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: buildFormList(_formKey, formConfigs, _register, context),
          ),
        ),
      ),
    );
  }
}
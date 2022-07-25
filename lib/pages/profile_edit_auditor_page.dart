import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/form_config_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:intl/intl.dart';

class ProfileEditAuditorPage extends StatefulWidget {
  const ProfileEditAuditorPage(this.userAuditorData, { Key? key }) : super(key: key);

  final UserAuditorData userAuditorData;

  @override
  State<ProfileEditAuditorPage> createState() => _ProfileEditAuditorPageState();
}

class _ProfileEditAuditorPageState extends State<ProfileEditAuditorPage> {
  final _coreService = CoreService();

  final _formKey = GlobalKey<FormState>();
  late List<FormConfig> _formsConfig;
  final _noKtpController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
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

  void _updateUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    try {
      final params = {
        'id': widget.userAuditorData.id,
        'no_ktp': _noKtpController.text,
        'name': _nameController.text,
        'username': _usernameController.text,
        'religion': _religionModel,
        'type': _typeController.text,
        'address': _addressController.text,
        'institution': _institutionController.text,
        'competence': _competenceController.text,
        'experience': _experienceController.text,
        'cert_competence': _certCompetenceController.text,
        'experied_cert': _expiredCertModel!.millisecondsSinceEpoch,
        'auditor_experience': _auditorExperienceController.text,
      };

      final response = await _coreService.updateUser(UserType.auditor, params);
      final newAuditorData = UserAuditorData.fromJSON({
        ...params,
        'role': widget.userAuditorData.role,
        'created_at': widget.userAuditorData.createdAt.millisecondsSinceEpoch,
      });
      
      final storage = FlutterSecureStorage();
      await storage.write(key: 'user_auditor', value: jsonEncode(newAuditorData.toJSON()));
      
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text('Sukses mennyunting akun!'));
        }
      );
    }

    catch(err, stacktrace) {
      print(stacktrace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(content: Text(message))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _noKtpController.text = widget.userAuditorData.noKtp;
    _nameController.text = widget.userAuditorData.name;
    _usernameController.text = widget.userAuditorData.username;
    _religionModel = widget.userAuditorData.religion;
    _typeController.text = widget.userAuditorData.getType();
    _addressController.text = widget.userAuditorData.address;
    _institutionController.text = widget.userAuditorData.institution;
    _competenceController.text = widget.userAuditorData.competence;
    _experienceController.text = widget.userAuditorData.experience;
    _certCompetenceController.text = widget.userAuditorData.certCompetence;
    _expiredCertController.text = DateFormat('yyyy/MM/dd').format(widget.userAuditorData.expiredCert);
    _expiredCertModel = widget.userAuditorData.expiredCert;
    _auditorExperienceController.text = widget.userAuditorData.auditorExperience;

    _formsConfig = [
      FormConfig(
        label: 'No. KTP',
        controller: _noKtpController,
        validator: validateRequired,
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
        label: 'Religion',
        type: FormConfigType.select,
        onChanged: (value) => _religionModel = value,
        value: _religionModel,
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
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Auditor')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: buildFormList(
              key: _formKey,
              configs: _formsConfig,
              context: context,
              onSubmit: _updateUser,
              submitText: 'Save'
            ),
          )
        )
      )
    );
  }
}
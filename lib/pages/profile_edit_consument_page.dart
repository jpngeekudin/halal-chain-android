import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/form_config_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/services/main_service.dart';

class ProfileEditConsumentPage extends StatefulWidget {
  const ProfileEditConsumentPage(this.consumentData, { Key? key }) : super(key: key);

  final UserConsumentData consumentData;

  @override
  State<ProfileEditConsumentPage> createState() => _ProfileEditConsumentPageState();
}

class _ProfileEditConsumentPageState extends State<ProfileEditConsumentPage> {
  final _coreService = CoreService();

  final _formKey = GlobalKey<FormState>();
  List<FormConfig> _formsConfig = [];
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  void _editUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    try {
      final params = {
        'id': widget.consumentData.id,
        'name': _nameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'role': widget.consumentData.role,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'created_at': widget.consumentData.createdAt.millisecondsSinceEpoch,
      };

      final response = await _coreService.updateUser(UserType.consument, params);
      final newConsumentData = UserConsumentData.fromJSON(params);
      final storage = FlutterSecureStorage();
      await storage.write(key: 'user_consumen', value: jsonEncode(newConsumentData.toJSON()));
      
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text('Sukses mennyunting akun!'));
        }
      );
    }

    catch(err) {
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

    _nameController.text = widget.consumentData.name;
    _usernameController.text = widget.consumentData.username;
    _emailController.text = widget.consumentData.email;
    _phoneController.text = widget.consumentData.phone;
    _addressController.text = widget.consumentData.address;

    _formsConfig = [
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
        label: 'Email',
        controller: _emailController,
        validator: validateEmail
      ),
      FormConfig(
        label: 'Phone',
        type: FormConfigType.number,
        controller: _phoneController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Address',
        controller: _addressController,
        validator: validateRequired
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Consument'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: buildFormList(
              key: _formKey,
              configs: _formsConfig,
              context: context,
              onSubmit: _editUser,
              submitText: 'Save'
            ),
          )
        ),
      ),
    );
  }
}
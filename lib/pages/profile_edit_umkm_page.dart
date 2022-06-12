import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/form_config_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/services/main_service.dart';

class ProfileEditUmkmPage extends StatefulWidget {
  const ProfileEditUmkmPage(this.userUmkmData, { Key? key }) : super(key: key);

  final UserUmkmData userUmkmData;

  @override
  State<ProfileEditUmkmPage> createState() => _ProfileEditUmkmPageState();
}

class _ProfileEditUmkmPageState extends State<ProfileEditUmkmPage> {
  final _coreService = CoreService();

  final _formKey = GlobalKey<FormState>();
  List<FormConfig> _formConfigs = [];
  final _usernameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyNumberController = TextEditingController();
  final _factoryNameController = TextEditingController();
  final _factoryAddressController = TextEditingController();
  final _emailController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _marketingAreaController = TextEditingController();
  final _marketingSystemController = TextEditingController();

  void _editUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    try {
      final params = {
        'id': widget.userUmkmData.id,
        'username': _usernameController.text,
        'company_name': _companyNameController.text,
        'company_address': _companyAddressController.text,
        'company_number': _companyNumberController.text,
        'factory_name': _factoryNameController.text,
        'factory_address': _factoryAddressController.text,
        'email': _emailController.text,
        'product_name': _productNameController.text,
        'product_type': _productTypeController.text,
        'marketing_area': _marketingAreaController.text,
        'marketing_system': _marketingSystemController.text,
      };

      final response = await _coreService.updateUser(UserType.umkm, params);
      final newUmkmData = UserUmkmData.fromJSON(params);
      final storage = FlutterSecureStorage();
      await storage.write(key: 'user_umkm', value: jsonEncode(newUmkmData.toJSON()));
      
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Sukses mennyunting akun!')
          );
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
    _usernameController.text = widget.userUmkmData.username;
    _companyNameController.text = widget.userUmkmData.companyName;
    _companyAddressController.text = widget.userUmkmData.companyAddress;
    _companyNumberController.text = widget.userUmkmData.companyNumber;
    _factoryNameController.text = widget.userUmkmData.factoryName;
    _factoryAddressController.text = widget.userUmkmData.factoryAddress;
    _emailController.text = widget.userUmkmData.email;
    _productNameController.text = widget.userUmkmData.productName;
    _productTypeController.text = widget.userUmkmData.productType;
    _marketingAreaController.text = widget.userUmkmData.marketingArea;
    _marketingSystemController.text = widget.userUmkmData.marketingSystem;

    _formConfigs = [
      FormConfig(
        label: 'Username',
        controller: _usernameController,
        validator: validateRequired
      ),
      FormConfig(
        label: 'Company Name',
        controller: _companyNameController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Company Address',
        controller: _companyAddressController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Company Number',
        controller: _companyNumberController,
        type: FormConfigType.number,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Factory Name',
        controller: _factoryNameController,
        validator: validateRequired
      ),
      FormConfig(
        label: 'Factory Address',
        controller: _factoryAddressController,
        validator: validateRequired
      ),
      FormConfig(
        label: 'Email',
        controller: _emailController,
        validator: validateEmail,
      ),
      FormConfig(
        label: 'Product Name',
        controller: _productNameController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Product Type',
        controller: _productTypeController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Marketing Area',
        controller: _marketingAreaController,
        validator: validateRequired,
      ),
      FormConfig(
        label: 'Marketing System',
        controller: _marketingSystemController,
        validator: validateRequired
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User UMKM'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: buildFormList(
              key: _formKey,
              configs: _formConfigs,
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
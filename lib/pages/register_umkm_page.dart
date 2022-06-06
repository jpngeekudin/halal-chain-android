import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/services/main_service.dart';

class RegisterUmkmPage extends StatefulWidget {
  const RegisterUmkmPage({ Key? key }) : super(key: key);

  @override
  State<RegisterUmkmPage> createState() => _RegisterUmkmPageState();
}

class _RegisterUmkmPageState extends State<RegisterUmkmPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
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

  InputDecoration _getInputDecoration({
    required String label
  }) => InputDecoration(
    hintText: label,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.grey[200],
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 10
    )
  );

  final _inputTextStyle = TextStyle(
    fontSize: 14
  );

  Widget _buildFormList(GlobalKey<FormState> key, List<FormConfig> configs, Function onSubmit) {
    List<Widget> formList = configs.map((config) {
      Widget input;

      if (config.type == FormConfigType.password) {
        input = TextFormField(
          controller: config.controller,
          decoration: _getInputDecoration(label: config.label),
          style: _inputTextStyle,
          validator: config.validator,
          obscureText: true,
          enableSuggestions: false,
        );
      }

      else if (config.type == FormConfigType.number) {
        input = TextFormField(
          controller: config.controller,
          decoration: _getInputDecoration(label: config.label),
          style: _inputTextStyle,
          validator: config.validator,
          keyboardType: TextInputType.number,
        );
      }

      else {
        input = TextFormField(
          controller: config.controller,
          decoration: _getInputDecoration(label: config.label),
          style: _inputTextStyle,
          validator: config.validator,
        );
      }

      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(config.label, style: TextStyle(
              fontWeight: FontWeight.bold
            )),
            SizedBox(height: 10),
            input,
          ],
        ),
      );
    }).toList();

    return Form(
      key: key,
      child: Column(
        children: [
          ...formList,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => onSubmit(),
                child: Text('Submit'),
              )
            ],
          )
        ],
      ),
    );
  }

  void _register() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    try {
      final response = await registerUmkm({
        'username': _usernameController.text,
        'password': _passwordController.text,
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
      });
      
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text('Sukses membuat akun!'));
        }
      );
      Navigator.of(context).pop();
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
  Widget build(BuildContext context) {
    final formConfigs = [
      FormConfig(type: FormConfigType.text, label: 'Username', controller: _usernameController, validator: validateRequired),
      FormConfig(type: FormConfigType.password, label: 'Password', controller: _passwordController, validator: validateRequired),
      FormConfig(type: FormConfigType.text, label: 'Company Name', controller: _companyNameController, validator: validateRequired),
      FormConfig(type: FormConfigType.text, label: 'Company Address', controller: _companyAddressController, validator: validateRequired),
      FormConfig(type: FormConfigType.number, label: 'Company Number', controller: _companyNumberController, validator: validateRequired),
      FormConfig(type: FormConfigType.text, label: 'Factory Name', controller: _factoryNameController, validator: validateRequired),
      FormConfig(type: FormConfigType.text, label: 'Factory Address', controller: _factoryAddressController, validator: validateRequired),
      FormConfig(type: FormConfigType.text, label: 'Email', controller: _emailController, validator: validateEmail),
      FormConfig(type: FormConfigType.text, label: 'Product Name', controller: _productNameController, validator: validateRequired),
      FormConfig(type: FormConfigType.text, label: 'Product Type', controller: _productTypeController, validator: validateRequired),
      FormConfig(type: FormConfigType.text, label: 'Marketing Area', controller: _marketingAreaController, validator: validateRequired),
      FormConfig(type: FormConfigType.text, label: 'Marketing System', controller: _marketingSystemController, validator: validateRequired)
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar UMKM')
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: _buildFormList(_formKey, formConfigs, _register),
          ),
        ),
      ),
    );
  }
}

class FormConfig {
  FormConfigType type = FormConfigType.text;
  late String label;
  late TextEditingController controller;
  String? Function(String?)? validator;

  FormConfig({
    required this.label,
    required this.controller,
    required this.type,
    this.validator,
  });
}

enum FormConfigType {
  text,
  password,
  number,
}
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/form_config_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';

class RegisterConsumenPage extends StatefulWidget {
  const RegisterConsumenPage({ Key? key }) : super(key: key);

  @override
  State<RegisterConsumenPage> createState() => _RegisterConsumenPageState();
}

class _RegisterConsumenPageState extends State<RegisterConsumenPage> {
  final _coreService = CoreService();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  void _register() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    try {
      final response = await _coreService.register(UserType.consument, {
        'name': _nameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text
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
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formConfigs = [
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
        validator: validateRequired,
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

    return Scaffold(
      appBar: AppBar(title: Text('Daftar Konsumen')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: buildFormList(
              key: _formKey,
              context: context,
              configs: formConfigs,
              onSubmit: _register,
            )
          )
        )
      ),
    );
  }
}
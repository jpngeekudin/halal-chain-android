import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/pages/home_page.dart';
import 'package:halal_chain/pages/register_page.dart';
import 'package:halal_chain/services/core_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _coreService = CoreService();
  final _usernameController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _navigateToRegister() {
    Navigator.of(context).pushNamed('/auth/register');
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final params = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };

    try {
      final response = await _coreService.login(params);
      setUserData(response.data);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }

    catch(err) {
      setState(() => _loading = false);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message)
        )
      );
    }


    // setState(() => _loading = true);
    // await Future.delayed(Duration(seconds: 3), () {});

    // if (_formKey.currentState!.validate()) {
    //   _loading = false;
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       Future.delayed(Duration(seconds: 3), () {
    //         Navigator.of(context).pop();
    //       });
    //       return AlertDialog(
    //         title: Text('Error'),
    //         content: Text('Login invalid'),
    //       );
    //     }
    //   );
    // }

    // else {
    //   final userData = { 'username': _usernameController.text };
    //   final storage = FlutterSecureStorage();
    //   await storage.write(key: 'user', value: jsonEncode(userData));
    //   setState(() => _loading = false);
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //     return HomePage();
    //   }));
    // }
    
    // setState(() {
    //   _loading = false;
    // });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text('🔗 Halal Chain', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32
                ),),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _usernameController,
                  validator: validateRequired,
                  decoration: getInputDecoration(
                    label: 'Username',
                    icon: Icon(Icons.person_outline)
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: _passwordController,
                  validator: validateRequired,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: getInputDecoration(
                    label: 'Password',
                    icon: Icon(Icons.vpn_key_outlined)
                  )
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: !_loading
                    ? () => _login()
                    : null,
                  child: !_loading
                  ? Text('Login', style: TextStyle(
                    fontWeight: FontWeight.bold
                  ))
                  : SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _navigateToRegister(),
                    child: Text('Register'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
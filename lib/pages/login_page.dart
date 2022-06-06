import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/pages/home_page.dart';
import 'package:halal_chain/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _loading = false;

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => RegisterPage())
    );
  }

  void _login() async {
    setState(() => _loading = true);
    await Future.delayed(Duration(seconds: 3), () {});

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _loading = false;
      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            title: Text('Error'),
            content: Text('Login invalid'),
          );
        }
      );
    }

    else {
      final userData = { 'username': _usernameController.text };
      final storage = FlutterSecureStorage();
      await storage.write(key: 'user', value: jsonEncode(userData));
      setState(() => _loading = false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
    
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text('🔗 Halal Chain', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32
              ),),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                ),
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
    );
  }
}
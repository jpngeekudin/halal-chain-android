import 'package:flutter/material.dart';
import 'package:halal_chain/helpers/auth_helper.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({ Key? key }) : super(key: key);

  void _checkLoggedInUser(BuildContext context) async {
    final user = await getUserData();
    if (user != null) Navigator.of(context).pushReplacementNamed('/home');
    else Navigator.of(context).pushReplacementNamed('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    _checkLoggedInUser(context);
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
    );
  }
}
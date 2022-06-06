import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halal_chain/pages/home_page.dart';
import 'package:halal_chain/pages/login_page.dart';
import 'package:halal_chain/pages/splash_screen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData _theme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      textTheme: GoogleFonts.robotoTextTheme(
        Theme.of(context).textTheme
      )
    );
  }

  Future<bool> _isLoggedIn() async {
    final storage = FlutterSecureStorage();
    final userDataStr = await storage.read(key: 'user');
    if (userDataStr != null) return true;
    else return false; 
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _theme(context),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _isLoggedIn(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data) return HomePage();
          else if (snapshot.hasData && !snapshot.data) return LoginPage();
          else return SplashScreenPage();
        },
      )
    );
  }
}
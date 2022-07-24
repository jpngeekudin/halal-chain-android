import 'package:flutter/material.dart';
import 'package:halal_chain/pages/register_auditor_page.dart';
import 'package:halal_chain/pages/register_consumen_page.dart';
import 'package:halal_chain/pages/register_umkm_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({ Key? key }) : super(key: key);

  Widget _choice({
    required String name,
    required String label,
    required BuildContext context
  }) {
    return InkWell(
      onTap: () => _navigateToRegister(context, name),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.circle, color: Theme.of(context).primaryColor),
            SizedBox(width: 10),
            Text(label, style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
          ],
        ),
      ),
    );
  }

  void _navigateToRegister(BuildContext context, String type) {
    if (type == 'umkm') {
      Navigator.of(context).pushNamed('/auth/register/umkm');
    }

    else if (type == 'auditor') {
      Navigator.of(context).pushNamed('/auth/register/auditor');
    }

    else if (type == 'consumen') {
      Navigator.of(context).pushNamed('/auth/register/consument');
    }
  }

  void _back(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Daftar sebagai akun', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24
            )),
            SizedBox(height: 30),
            _choice(name: 'umkm', label: 'UMKM', context: context),
            SizedBox(height: 20),
            _choice(name: 'auditor', label: 'Auditor', context: context),
            SizedBox(height: 20),
            _choice(name: 'consumen', label: 'Consumen', context: context),
            SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                  onPressed: () => _back(context),
                  child: Text('Kembali'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
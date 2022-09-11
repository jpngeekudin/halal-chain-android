import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ConsumentScanPage extends StatefulWidget {
  const ConsumentScanPage({Key? key}) : super(key: key);

  @override
  State<ConsumentScanPage> createState() => _ConsumentScanPageState();
}

class _ConsumentScanPageState extends State<ConsumentScanPage> {

  // void scan() async {
  //   var result = await Barcode
  // }

  void _onScan(String umkmId) {
    Navigator.of(context).pushNamed('/consument/qr-detail',
      arguments: { 'umkmId': umkmId }
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(
              allowDuplicates: false,
              onDetect: (barcode, args) {
                Logger logger = Logger();
                if (barcode.rawValue == null) {
                  logger.e('Failed to scan barcode');
                } else {
                  String code = barcode.rawValue!;
                  logger.i(code);
                  _onScan(code);
                }
              }
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 150),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.2),
                    ),
                    child: Text('Scan QR Code', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
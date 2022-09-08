import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Widget getDottedBorder({
  required Widget child,
  Color color = Colors.black,
  double radius = 5.0
}) {
  return DottedBorder(
    color: color,
    customPath: (size) {
      final cardRadius = radius;
      return Path()
        ..moveTo(cardRadius, 0)
        ..lineTo(size.width - cardRadius, 0)
        ..arcToPoint(Offset(size.width, cardRadius), radius: Radius.circular(cardRadius))
        ..lineTo(size.width, size.height - cardRadius)
        ..arcToPoint(Offset(size.width - cardRadius, size.height), radius: Radius.circular(cardRadius))
        ..lineTo(cardRadius, size.height)
        ..arcToPoint(Offset(0, size.height - cardRadius), radius: Radius.circular(cardRadius))
        ..lineTo(0, cardRadius)
        ..arcToPoint(Offset(cardRadius, 0), radius: Radius.circular(cardRadius));
    },
    child: child
  );
}

Future<File> uint8ListToFile(Uint8List src) async {
  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/image.png').create();
  file.writeAsBytesSync(src);
  return file;
}

bool toBool(dynamic value) {
  return ["", null, false, 0].contains(value);
}
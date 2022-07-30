import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getHeader({
  required BuildContext context,
  required String text,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    child: Text(text, style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Theme.of(context).primaryColor
    )),
  );
}

Widget getPlaceholder({
  required String text,
}) {
  return Text(text, style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey
  ));
}
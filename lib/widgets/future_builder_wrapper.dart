import 'package:flutter/material.dart';

Widget futureBuilderWrapper({
  required AsyncSnapshot snapshot,
  required Widget child
}) {
  if (snapshot.hasData) {
    return child;
  }

  else if (snapshot.hasError) {
    return Container(
      alignment: Alignment.center,
      child: Text(snapshot.error.toString(), style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey[600]
      )),
    );
  }

  else return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(),
  );
}
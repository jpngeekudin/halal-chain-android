import 'package:flutter/material.dart';

Widget wrapHorizontal(List<Widget> children) {
  return Wrap(
    direction: Axis.horizontal,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
}
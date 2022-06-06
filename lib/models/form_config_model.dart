import 'package:flutter/material.dart';

class FormConfig {
  FormConfigType type = FormConfigType.text;
  late String label;
  late TextEditingController controller;
  String? Function(String?)? validator;

  FormConfig({
    required this.label,
    required this.controller,
    required this.type,
    this.validator,
  });
}

enum FormConfigType {
  text,
  password,
  number,
}
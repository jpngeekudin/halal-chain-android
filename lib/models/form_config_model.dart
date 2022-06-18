import 'package:flutter/material.dart';

class FormConfig {
  String label;
  TextEditingController? controller;
  FormConfigType type;
  String? Function(String?)? validator;
  void Function(dynamic)? onChanged;
  List<FormConfigOption> options;
  dynamic? value;

  FormConfig({
    required this.label,
    this.controller,
    this.type = FormConfigType.text,
    this.validator,
    this.onChanged,
    this.options = const [],
    this.value
  });
}

class FormConfigOption {
  String value;
  String label;

  FormConfigOption(this.value, this.label);
}

enum FormConfigType {
  text,
  password,
  number,
  select,
  date,
  file
}
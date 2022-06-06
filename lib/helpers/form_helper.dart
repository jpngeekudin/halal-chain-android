import 'package:flutter/material.dart';
import 'package:halal_chain/models/form_config_model.dart';

String? validateRequired(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please fill this field';
  } else {
    return null;
  }
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Please fill this field';
  final isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
  if (!isEmail) return 'Please input valid email';
  else return null;
}

InputDecoration getInputDecoration({
  required String label,
  Icon? icon,
}) => InputDecoration(
  hintText: label,
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
  ),
  prefixIcon: icon,
  filled: true,
  fillColor: Colors.grey[200],
  isDense: true,
  contentPadding: EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10
  )
);

final inputTextStyle = TextStyle(
  fontSize: 14
);

Widget buildFormList(GlobalKey<FormState> key, List<FormConfig> configs, Function onSubmit) {
  List<Widget> formList = configs.map((config) {
    Widget input;

    if (config.type == FormConfigType.password) {
      input = TextFormField(
        controller: config.controller,
        decoration: getInputDecoration(label: config.label),
        style: inputTextStyle,
        validator: config.validator,
        obscureText: true,
        enableSuggestions: false,
      );
    }

    else if (config.type == FormConfigType.number) {
      input = TextFormField(
        controller: config.controller,
        decoration: getInputDecoration(label: config.label),
        style: inputTextStyle,
        validator: config.validator,
        keyboardType: TextInputType.number,
      );
    }

    else {
      input = TextFormField(
        controller: config.controller,
        decoration: getInputDecoration(label: config.label),
        style: inputTextStyle,
        validator: config.validator,
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(config.label, style: TextStyle(
            fontWeight: FontWeight.bold
          )),
          SizedBox(height: 10),
          input,
        ],
      ),
    );
  }).toList();

  return Form(
    key: key,
    child: Column(
      children: [
        ...formList,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => onSubmit(),
              child: Text('Submit'),
            )
          ],
        )
      ],
    ),
  );
}
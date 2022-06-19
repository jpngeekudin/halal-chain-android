import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/models/form_config_model.dart';
import 'package:intl/intl.dart';

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
  fontSize: 14,
);

Widget getInputWrapper({
  required String label,
  required Widget input,
}) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          fontWeight: FontWeight.bold
        )),
        SizedBox(height: 10),
        input,
      ],
    ),
  );
}

Widget getInputFile({
  required File? model,
  required Function(File? file) onChanged,
  required BuildContext context,
}) {
  return model == null
    // ? ElevatedButton(
    //   child: Wrap(
    //     crossAxisAlignment: WrapCrossAlignment.center,
    //     children: [
    //       Icon(Icons.file_copy),
    //       SizedBox(width: 10),
    //       Text('Pick File')
    //     ]
    //   ),
    //   onPressed: () async {
    //     final result = await FilePicker.platform.pickFiles();
    //     if (result != null) onChanged(File(result.files.single.path!));
    //   },
    // ) :
    ? InkWell(
      child: DottedBorder(
        color: Theme.of(context).primaryColor,
        customPath: (size) {
          const cardRadius = 5.0;
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
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor.withOpacity(.02),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, color: Theme.of(context).primaryColor),
                SizedBox(width: 5),
                Text('Add File', style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).primaryColor
                ))
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        final result = await FilePicker.platform.pickFiles();
        if (result != null) onChanged(File(result.files.single.path!));
      },
    ) :
    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.file(model)
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          child: Text('Remove'),
          style: ElevatedButton.styleFrom(primary: Colors.red),
          onPressed: () => onChanged(null)
        )
      ],
    );
} 

Widget buildFormList({
  required GlobalKey<FormState> key,
  required List<FormConfig> configs,
  required Function onSubmit,
  required BuildContext context,
  String submitText = 'Submit'
}) {
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      );
    }

    else if (config.type == FormConfigType.select) {
      input = DropdownButtonFormField(
        items: config.options.map((opt) => DropdownMenuItem(
          value: opt.value,
          child: Text(opt.label),
        )).toList(),
        onChanged: config.onChanged,
        decoration: getInputDecoration(label: config.label),
        isDense: true,
        value: config.value,
      );
    }

    else if (config.type == FormConfigType.date) {
      input = TextFormField(
        controller: config.controller,
        decoration: getInputDecoration(label: config.label),
        style: inputTextStyle,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: defaultDateFormat.parse(config.controller!.text),
            firstDate: DateTime(2016),
            lastDate: DateTime(2100),
          );

          if (picked != null && config.onChanged != null) config.onChanged!(picked);
          if (picked != null && config.controller != null) config.controller!.text = defaultDateFormat.format(picked);
        },
      );
    }

    else if (config.type == FormConfigType.file) {
      input = getInputFile(
        model: config.value,
        onChanged: config.onChanged!,
        context: context
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

    return getInputWrapper(
      label: config.label,
      input: input,
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
              child: Text(submitText),
            )
          ],
        )
      ],
    ),
  );
}
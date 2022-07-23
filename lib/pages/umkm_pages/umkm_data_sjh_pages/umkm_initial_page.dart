import 'package:flutter/material.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/form_config_model.dart';

class UmkmInitialPage extends StatefulWidget {
  const UmkmInitialPage({ Key? key }) : super(key: key);

  @override
  State<UmkmInitialPage> createState() => _UmkmInitialPageState();
}

class _UmkmInitialPageState extends State<UmkmInitialPage> {

  List<FormConfig> _formConfigs = [];
  final _formKey = GlobalKey<FormState>();

  void _submit() { }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Auditor')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: buildFormList(
              key: _formKey,
              configs: _formConfigs,
              context: context,
              onSubmit: _submit,
            ),
          ),
        ),
      ),
    );
  }
}
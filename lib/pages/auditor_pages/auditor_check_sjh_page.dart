import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/api_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';
import 'package:recase/recase.dart';

class AuditorCheckSjhPage extends StatefulWidget {
  const AuditorCheckSjhPage({ Key? key }) : super(key: key);

  @override
  State<AuditorCheckSjhPage> createState() => _AuditorCheckSjhPageState();
}

class _AuditorCheckSjhPageState extends State<AuditorCheckSjhPage> {

  String? _error;
  List<SjhData> _sjhData = [];
  // final resultController = TextEditingController();
  String? _resultModel;
  final _descriptionController = TextEditingController();

  Future _getSjhData() async {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final id = args['id'];

    try {
      final core = CoreService();
      final params = { 'umkm_id': id };
      final response = await core.genericGet(ApiList.coreGetUmkmRegistrationData, params);
      setState(() {
        _error = null;
        _sjhData = response.data.entries
          .where((entry) => entry.key != 'password')
          .map<SjhData>((entry) {
            final String key = ReCase(entry.key).sentenceCase;
            dynamic value;
            if (entry.key == 'created_at') value = defaultDateFormat.format(DateTime.fromMillisecondsSinceEpoch(entry.value));
            else value = entry.value;
            return SjhData(key, value);
          })
          .toList();
      });
    }

    catch(err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['data'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() => _error = message);
    }
  }

  Future _submit() async {
    if (_resultModel == null || _resultModel!.isEmpty || _descriptionController.text.isEmpty) {
      const snackBar = SnackBar(content: Text('Harap isi semua field'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final umkmId = args['id'];
      final String checkType = args['checkType'];
      final user = await getUserData();

      final core = CoreService();
      Map<String, dynamic> params;
      if (checkType == 'check-bpjph') params = {
        'umkm_id': umkmId,
        'BPJPH_id': user!.id,
        'result': _resultModel,
        'description': _descriptionController.text
      };
      else params = {
        'umkm_id': umkmId,
        'lph_id': user!.id,
        'status': _resultModel,
        'description': _descriptionController.text
      };

      String url;
      if (checkType == 'check-bpjph') url = ApiList.coreBpjphCheckingData;
      else if (checkType == 'check-lph') url = ApiList.coreLphCheckingData;
      else if (checkType == 'review-place') url = ApiList.coreReviewBussinessPlace;
      else url = ApiList.coreBpjphCheckingData;

      final logger = Logger();
      logger.i(url);
      logger.i(params);

      final response = await core.genericPost(url, null, params);
      Navigator.pop(context);
      final snackBar = SnackBar(content: Text('Sukses menyimpan data!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err, trace) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getSjhData();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String checkType = args['checkType'];

    String title;
    if (checkType == 'review-place') title = 'Review Tempat Bisnis';
    else title = 'Check SJH';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: _error == null
          ? SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SJH Data', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )),
                  SizedBox(height: 10),
                  ..._sjhData.map((data) {
                    final index = _sjhData.indexOf(data);
                    return Column(
                      children: [
                        if (index > 0) Divider(),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(data.key),
                              Text(data.value.toString(), style: TextStyle(
                                fontWeight: FontWeight.bold
                              ))
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 30),
                  Text('Check Data', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  )),
                  SizedBox(height: 10),
                  getInputWrapper(
                    label: 'Result',
                    input: SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField(
                        decoration: getInputDecoration(label: 'Result'),
                        isDense: true,
                        items: [
                          DropdownMenuItem(
                            child: Text('Data sudah valid'),
                            value: 'approved',
                          ),
                          DropdownMenuItem(
                            child: Text('Data belum valid'),
                            value: 'declined'
                          )
                        ],
                        value: _resultModel,
                        onChanged: (String? value) {
                          setState(() => _resultModel = value);
                        }
                      ),
                    ),
                    // input: TextFormField(
                    //   controller: resultController,
                    //   decoration: getInputDecoration(label: 'Result'),
                    //   style: inputTextStyle,
                    //   validator: validateRequired,
                    // ),
                  ),
                  getInputWrapper(
                    label: 'Deskripsi',
                    input: TextFormField(
                      controller: _descriptionController,
                      decoration: getInputDecoration(label: 'Deskripsi'),
                      style: inputTextStyle,
                      validator: validateRequired,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () => _submit(),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
          : Container(
            height: 400,
            alignment: Alignment.center,
            child: Text(_error!, style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600]
            )),
          )
      ),
    );
  }
}

class SjhData {
  String key;
  dynamic value;

  SjhData(this.key, this.value);
}
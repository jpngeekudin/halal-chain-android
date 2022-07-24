import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class AuditorAppointLphPage extends StatefulWidget {
  const AuditorAppointLphPage({ Key? key }) : super(key: key);

  @override
  State<AuditorAppointLphPage> createState() => _AuditorAppointLphPageState();
}

class _AuditorAppointLphPageState extends State<AuditorAppointLphPage> {

  List<UserAuditorData> _listAuditor = [];
  String? _lphIdModel;

  Future _getLphList() async {
    try {
      final core = CoreService();
      final params = { 'location': 'cikamunding' };
      final response = await core.genericGet(ApiList.coreGetLph, params);
      setState(() {
        _listAuditor = response.data
          .map<UserAuditorData>((d) => UserAuditorData.fromJSON(d))
          .toList();
      });
    }

    catch(err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future _submit() async {
    if (_lphIdModel == null || _lphIdModel!.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap pilih LPH!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final umkmId = args['id'];

    try {
      final core = CoreService();
      final user = await getUserData();
      final params = {
        'bpjphh_id': user!.id,
        'lph_id': _lphIdModel,
        'umkm_id': umkmId,
      };
      final response = await core.genericPost(ApiList.coreLphAppointment, null, params);
      Navigator.of(context).pop();
      final snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data?['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    _getLphList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appoint LPH'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text('Silahkan pilih LPH yang akan ditunjuk untuk melakukan pengecekan SJH UMKM', style: TextStyle(
                  color: Colors.grey[600]
                )),
                SizedBox(height: 30),
                getInputWrapper(
                  label: 'Select LPH',
                  input: DropdownButtonFormField(
                    decoration: getInputDecoration(label: 'Select LPH'),
                    isDense: true,
                    value: _lphIdModel,
                    items: _listAuditor.map((auditor) {
                      return DropdownMenuItem(
                        value: auditor.id,
                        child: Text(auditor.name),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() => _lphIdModel = value);
                    }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _submit(),
                      child: Text('Submit'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
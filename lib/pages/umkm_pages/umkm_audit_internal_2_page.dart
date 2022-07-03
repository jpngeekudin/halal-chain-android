import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmAuditInternal2Page extends StatefulWidget {
  const UmkmAuditInternal2Page({ Key? key }) : super(key: key);

  @override
  State<UmkmAuditInternal2Page> createState() => _UmkmAuditInternal2PageState();
}

class _UmkmAuditInternal2PageState extends State<UmkmAuditInternal2Page> {
  final _core = CoreService();
  final _logger = Logger();
  List<UmkmSoalAudit> _soalList = [];

  final _auditeeController = TextEditingController();
  final _namaAuditorController = TextEditingController();
  final _bagianDiauditController = TextEditingController();
  final _tanggalAuditController = TextEditingController();
  DateTime? _tanggalAuditModel;

  Future<List<UmkmSoalAudit>?> _getSoal() async {
    try {
      final response = await _core.genericGet(ApiList.umkmGetAuditSoal, {});
      final soalList = response.data.map<UmkmSoalAudit>((d) => UmkmSoalAudit(d['id'], d['soal'])).toList();
      return soalList;
    }

    catch(err, trace) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
        )
      );
    }
  }

  void _submit() async {
    if (
      _auditeeController.text.isEmpty ||
      _namaAuditorController.text.isEmpty ||
      _bagianDiauditController.text.isEmpty ||
      _tanggalAuditModel == null
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi seluruh field yang dibutuhkan'))
      );
      return;
    }

    final allAnswered = _soalList.every((element) => element.jawaban != null);
    if (!allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap jawab seluruh soal.'))
      );
      return;
    }

    final document = await getUmkmDocument();
    final params = {
      'id': document!.id,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'tanggal_audit': _tanggalAuditModel!.millisecondsSinceEpoch,
      'auditee': _auditeeController.text,
      'nama_auditor': _namaAuditorController.text,
      'bagian_diaudit': _bagianDiauditController.text,
      'data': _soalList.map<Map<String, dynamic>>((soal) {
        return { 'id': soal.id, 'jawaban': soal.jawaban, 'keterangan': soal.keterangan?.text ?? '' };
      }).toList(),
    };

    try {
      final response = await _core.genericPost('http://103.176.79.228:5000/umkm/jawaban_audit_internal', null, params);
      const snackBar = SnackBar(content: Text('Sukses menyimpan data!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }

    catch(err, stacktrace) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audit Internal'),),
      body: SafeArea(
        child: FutureBuilder(
          future: _getSoal(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (_soalList.isEmpty) _soalList = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Column(
                          children: [
                            getInputWrapper(
                              label: 'Auditee',
                              input: TextFormField(
                                controller: _auditeeController,
                                decoration: getInputDecoration(label: 'Auditee'),
                                style: inputTextStyle,
                                validator: validateRequired,
                              )
                            ),
                            getInputWrapper(
                              label: 'Nama Auditor',
                              input: TextFormField(
                                controller: _namaAuditorController,
                                decoration: getInputDecoration(label: 'Nama Auditor'),
                                style: inputTextStyle,
                                validator: validateRequired,
                              )
                            ),
                            getInputWrapper(
                              label: 'Bagian yang diaudit',
                              input: TextFormField(
                                controller: _bagianDiauditController,
                                decoration: getInputDecoration(label: 'Bagian yang diaudit'),
                                style: inputTextStyle,
                                validator: validateRequired,
                              )
                            ),
                            getInputWrapper(
                              label: 'Tanggal Audit', 
                              input: TextFormField(
                                controller: _tanggalAuditController,
                                decoration: getInputDecoration(label: 'Tanggal Audit'),
                                style: inputTextStyle,
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _tanggalAuditController.text.isNotEmpty
                                      ? defaultDateFormat.parse(_tanggalAuditController.text)
                                      : DateTime.now(),
                                    firstDate: DateTime(2016),
                                    lastDate: DateTime(2100),
                                  );

                                  if (picked != null) {
                                    setState(() {
                                      _tanggalAuditModel = picked;
                                      _tanggalAuditController.text = defaultDateFormat.format(picked);
                                    });
                                  }
                                },
                              )
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text('Audit', style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )),
                      ),
                      ..._soalList.map((soal) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Column(
                            children: [
                              Text(soal.soal, style: TextStyle(
                                fontSize: 14
                              )),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  ElevatedButton(
                                    child: Text('Ya', style: TextStyle(
                                      color: soal.jawaban == true
                                        ? Colors.white
                                        : Colors.black
                                    )),
                                    onPressed: () {
                                      setState(() => soal.jawaban = true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: soal.jawaban == true
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[200]
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    child: Text('Tidak', style: TextStyle(
                                      color: soal.jawaban == false
                                        ? Colors.white
                                        : Colors.black
                                    )),
                                    onPressed: () {
                                      setState(() => soal.jawaban = false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: soal.jawaban == false
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[200]
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: soal.keterangan,
                                decoration: InputDecoration(
                                  label: Text('Keterangan'),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10
                                  )
                                ),
                                style: inputTextStyle,
                              )
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text('Submit'),
                          onPressed: () => _submit(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            else if (snapshot.hasError) {
              return Container(
                height: 400,
                alignment: Alignment.center,
                child: Text(snapshot.error.toString()),
              );
            }

            else {
              return Container(
                height: 400,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }
          }
        )
      ),
    );
  }
}
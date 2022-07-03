import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmEvaluasiPage extends StatefulWidget {
  const UmkmEvaluasiPage({ Key? key }) : super(key: key);

  @override
  State<UmkmEvaluasiPage> createState() => _UmkmEvaluasiPageState();
}

class _UmkmEvaluasiPageState extends State<UmkmEvaluasiPage> {
  final _core = CoreService();
  final _logger = Logger();
  final _namaController = TextEditingController();
  List<UmkmSoalEvaluasi> _soalList = [];
  int _currentSoal = -1;
  bool _loading = false;

  Future<List<UmkmSoalEvaluasi>?> _getSoal() async {
    if (_soalList.isNotEmpty) return _soalList;
    try {
      final response = await _core.getSoalEvaluasi();
      final soalList = response.data.map<UmkmSoalEvaluasi>((d) => UmkmSoalEvaluasi.fromJSON(d)).toList();
      return soalList;
    } catch(err) {
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

  void _setJawaban(UmkmJawabSoalEvaluasi jawaban) {
    setState(() {
      _soalList[_currentSoal].setJawaban(jawaban.key);
      print(_soalList[_currentSoal].jawaban);
    });
  }

  void _nextSoal() {
    if (_namaController.text.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap masukkan nama terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() => _currentSoal++);
  }

  void _prevSoal() {
    setState(() => _currentSoal--);
  }

  void _submit() async {
    if (_namaController.text.isEmpty) {
      const snackBar = SnackBar(content: Text('Harap isi nama terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final answeredAll = _soalList.every((element) => element.jawaban != null && element.jawaban!.isNotEmpty);
    if (!answeredAll) {
      const snackBar = SnackBar(content: Text('Harap isi semua soal.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();
    Map<dynamic, dynamic> params = {
      'id': document!.id,
      'nama': _namaController.text,
      'tanggal': DateTime.now().millisecondsSinceEpoch,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'data': {}
    };

    _soalList.forEach((soal) => params['data'][soal.id.toString()] = soal.jawaban);
    
    try {
      setState(() => _loading = true);
      final response = await _core.genericPost(ApiList.umkmCreateEvaluasiJawaban, null, params);
      const snackBar = SnackBar(content: Text('Sukses menyimpan data!'));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      setState(() => _loading = false);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluasi'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
            future: _getSoal(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                _soalList = snapshot.data;
                return Stack(
                  children: [
                    if (_currentSoal < 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getInputWrapper(
                            label: 'Nama',
                            input: TextField(
                              controller: _namaController,
                              decoration: getInputDecoration(label: 'Nama'),
                              style: inputTextStyle,
                            )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                child: Text('Next'),
                                onPressed: _nextSoal,
                              )
                            ],
                          )
                        ],
                      ),
                    
                    if (_currentSoal >= 0) 
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_soalList[_currentSoal].soal, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                          SizedBox(height: 20),
                          ..._soalList[_currentSoal].jawabanList.map((jawaban) {
                            return InkWell(
                              onTap: () => _setJawaban(jawaban),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: _soalList[_currentSoal].jawaban == jawaban.key
                                    ? Theme.of(context).primaryColor.withOpacity(.2)
                                    : null
                                ),
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(bottom: 10),
                                width: double.infinity,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(jawaban.key, style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _soalList[_currentSoal].jawaban == jawaban.key
                                        ? Theme.of(context).primaryColor
                                        : null
                                    )),
                                    SizedBox(width: 10),
                                    Text(jawaban.value,  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _soalList[_currentSoal].jawaban == jawaban.key
                                        ? Theme.of(context).primaryColor
                                        : null
                                    ))
                                  ],
                                ),
                              ),
                            );
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: _currentSoal >= 0
                                  ? ElevatedButton(
                                      child: Text('Back', style: TextStyle(
                                        color: Colors.black,
                                      )),
                                    onPressed: _prevSoal,
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey[200],
                                    ),
                                  )
                                : null,
                              ),
                              Container(
                                child: _currentSoal < _soalList.length - 1
                                  ? ElevatedButton(
                                    child: Text('Next'),
                                    onPressed: _nextSoal,
                                  )
                                  : ElevatedButton(
                                    child: Text('Submit'),
                                    onPressed: _submit,
                                  ),
                              )
                            ],
                          )
                        ]
                      ),
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: double.infinity,
                        height: 50,
                        child: LinearProgressIndicator(
                          value: _currentSoal / (_soalList.length - 1),
                        ),
                      ),
                    ),
                  ],
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
            },
          ),
        )
      ),
    );
  }
}
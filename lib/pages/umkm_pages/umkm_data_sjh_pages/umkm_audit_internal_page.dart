import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmAuditInternalPage extends StatefulWidget {
  const UmkmAuditInternalPage({ Key? key }) : super(key: key);

  @override
  State<UmkmAuditInternalPage> createState() => _UmkmAuditInternalPageState();
}

class _UmkmAuditInternalPageState extends State<UmkmAuditInternalPage> {
  final _core = CoreService();
  final _logger = Logger();

  final _keteranganController = TextEditingController();
  List<UmkmSoalAudit> _soalList = [];
  int _currentSoal = 0;

  Future<List<UmkmSoalAudit>?> _getSoal() async {
    try {
      final response = await _core.genericGet(ApiList.umkmGetAuditSoal, {});
      final soalList = response.data.map<UmkmSoalAudit>((d) => UmkmSoalAudit(d['id'], d['soal'])).toList();
      return soalList;
    }

    catch(err, trace) {
      _logger.e(err);
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

  Widget _getAnswerButton(bool answer) {
    return InkWell(
      onTap: () => _setJawaban(answer),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor
          ),
          borderRadius: BorderRadius.circular(10),
            color: _soalList[_currentSoal].jawaban == answer
              ? Theme.of(context).primaryColor.withOpacity(.2)
              : null
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        child: Text(answer ? 'Ya' : 'Tidak', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _soalList[_currentSoal].jawaban == answer
            ? Theme.of(context).primaryColor
            : null
        ))
      ),
    );
  }

  void _nextSoal() {
    setState(() => _currentSoal++);
  }

  void _prevSoal() {
    setState(() => _currentSoal--);
  }

  void _setJawaban(bool jawaban) {
    setState(() {
      _soalList[_currentSoal].setJawaban(jawaban);
    });
  }

  void _submit() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audit Internal'),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_soalList[_currentSoal].soal, style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                        SizedBox(height: 20),
                        _getAnswerButton(true),
                        _getAnswerButton(false),
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: TextField(
                            controller: _soalList[_currentSoal].keterangan,
                            decoration: InputDecoration(
                              label: Text('Keterangan'),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10
                              )
                            )
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: _currentSoal > 0
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
          )
        ),
      ),
    );
  }
}
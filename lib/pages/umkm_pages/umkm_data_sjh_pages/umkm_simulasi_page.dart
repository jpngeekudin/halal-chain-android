import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmSimulasiPage extends StatefulWidget {
  const UmkmSimulasiPage({ Key? key }) : super(key: key);

  @override
  State<UmkmSimulasiPage> createState() => _UmkmSimulasiPageState();
}

class _UmkmSimulasiPageState extends State<UmkmSimulasiPage> {
  final _core = CoreService();
  final _logger = Logger();

  // global key
  final GlobalKey<FormState> _formBahanKey = GlobalKey();
  final GlobalKey<FormFieldState<bool>> _formFieldHalalKey = GlobalKey();

  // model
  String _bahanModel = '';
  bool _halalModel = false;
  String _nomorSertifikatModel = '';

  // list
  List<UmkmSimulasiBahan>? _listBahan;
  bool _listBahanSubmitted = false;
  
  Future<List<UmkmSimulasiBahan>> _getBahanSimulasi() async {
    if (_listBahan != null) {
      return _listBahan!;
    }

    try {
      final user = await getUserData();
      final params = { 'creator_id': user!.id };
      // final response = await _core.genericGet(ApiList.simulasiGetBahan, params);
      final response = await _core.genericGet('', params);
      _listBahanSubmitted = true;
      return response.data.map<UmkmSimulasiBahan>((d) => UmkmSimulasiBahan(
        bahan: d['bahan'],
        halal: d['halal'],
        nomorSertifikat: int.parse(d['nomor_sertifikat']),
        inputDate: DateTime.fromMicrosecondsSinceEpoch(int.parse(d['input_date'])),
        updateDate: DateTime.fromMicrosecondsSinceEpoch(int.parse(d['update_date']))
      )).toList();
    }

    catch(err, trace) {
      _logger.d(trace);
      if (err is DioError && err.response?.data['message'] == 'failed') {
        _listBahanSubmitted = false;
        return [];
      }

      _logger.e(err);
      rethrow;
    }
  }

  void _addBahan() {
    if (!_formBahanKey.currentState!.validate()) {
      const snackBar = SnackBar(content: Text('Harap isi semua field!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    _formBahanKey.currentState!.save();
    final bahan = UmkmSimulasiBahan(
      bahan: _bahanModel,
      halal: _halalModel,
      nomorSertifikat: _nomorSertifikatModel.isNotEmpty
        ? int.parse(_nomorSertifikatModel)
        : null,
    );

    _listBahan!.add(bahan);
    _bahanModel = '';
    _halalModel = false;
    _nomorSertifikatModel = '';
    setState(() {});
    Navigator.of(context).pop();
  }

  void _removeBahan(UmkmSimulasiBahan bahan) {
    setState(() {
      _listBahan!.remove(bahan);
    });
  }

  void _openTambahBahanModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formBahanKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Text('Tambah Bahan', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: getInputDecoration(label: 'Bahan'),
                          style: inputTextStyle,
                          validator: validateRequired,
                          onSaved: (value) => _bahanModel = value!,
                        ),
                        FormField(
                          key: _formFieldHalalKey,
                          initialValue: false,
                          onSaved: (bool? value) => _halalModel = value!,
                          builder: (FormFieldState<bool> field) {
                            return SwitchListTile(
                              title: Text('Halal'),
                              value: field.value ?? false,
                              onChanged: (val) {
                                field.didChange(val);
                                setModalState(() {});
                              },
                            );
                          },
                        ),
                        if (_formFieldHalalKey.currentState?.value ?? false) TextFormField(
                          decoration: getInputDecoration(label: 'Nomor Sertifikat'),
                          style: inputTextStyle,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onSaved: (value) => _nomorSertifikatModel = value!,
                          validator: (value) {
                            final halal = _formFieldHalalKey.currentState?.value ?? false;
                            if (halal && value!.isEmpty) return 'Please fill this field!';
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.add_circle, color: Colors.black),
                                  SizedBox(width: 10),
                                  Text('Tambah', style: TextStyle(
                                    color: Colors.black
                                  ))
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200]
                              ),
                              onPressed: () => _addBahan(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ),
            );
          }
        );
      }
    );
  }

  void _submitBahan() async {
    if (_listBahan!.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap isi daftar bahan terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    
    try {
      final user = await getUserData();
      final params = {
        'creator_id': user!.id,
        'first_insert_date': DateTime.now().millisecondsSinceEpoch,
        'detail_bahan': _listBahan!.map((bahan) => bahan.toJSON()).toList(),
      };
      // final url = _listBahanSubmitted ? ApiList.simulasiUpdateBahan : ApiList.simulasiInputBahan;
      const url = '';
      final response = await _core.genericPost(url, {}, params);
      _listBahanSubmitted = true;
      _logger.i(response.data);

      final snackBar = SnackBar(content: Text('Sukses menyimpan data!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      _logger.e(err);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _submitSimulasi() async {
    if (!_listBahanSubmitted) {
      final snackBar = SnackBar(content: Text('Harap submit list bahan terlebih dahulu!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final user = await getUserData();
      final params = {
        'creator_id': user!.id,
        'registered': true
      };
      // final response = await _core.genericPost(ApiList.simulasiSJH, params, {});
      final response = await _core.genericPost('', params, {});
      _logger.i(response.data);

      Navigator.of(context).pop();
      final snackBar = SnackBar(content: Text(response.data['message'] ?? 'Sukses menyimpan data!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['data']['message'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulasi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: FutureBuilder(
              future: _getBahanSimulasi(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  _listBahan = data;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('List Bahan', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          )),
                          TextButton(
                            onPressed: () => _openTambahBahanModal(),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 10),
                                Text('Tambah Bahan')
                              ],
                            )
                          )
                        ],
                      ),

                      // no bahan container
                      SizedBox(height: 10),
                      if (_listBahan?.isEmpty ?? true) Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: Text('Belum ada list bahan', style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )),
                      )

                      // list bahan
                      else ListView(
                        shrinkWrap: true,
                        children: _listBahan!.map<Widget>((bahan) {
                          return ListTile(
                            title: Text(bahan.bahan, style: TextStyle(
                              fontWeight: FontWeight.bold
                            )),
                            subtitle: bahan.halal
                              ? Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 18,),
                                  SizedBox(width: 5),
                                  Text(bahan.nomorSertifikat.toString(), style: TextStyle(
                                    color: Colors.green,
                                  ))
                                ],
                              )
                              : Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.error, color: Colors.red, size: 18),
                                  SizedBox(width: 5),
                                  Text('Tidak halal', style: TextStyle(
                                    color: Colors.red
                                  ))
                                ],
                              ),
                              trailing: TextButton(
                                child: Icon(Icons.remove, color: Colors.red),
                                onPressed: () => _removeBahan(bahan),
                              ),
                          );
                        }).toList(),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.add_circle, color: Colors.black, size: 16),
                                SizedBox(width: 10),
                                Text('Submit Bahan', style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14
                                ))
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[200]
                            ),
                            onPressed: () => _submitBahan(),
                          )
                        ],
                      ),
                      SizedBox(height: 10),

                      // submit simulasi SJH
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text('Submit'),
                          onPressed: _listBahanSubmitted
                            ? () => _submitSimulasi()
                            : null,
                        ),
                      )
                    ],
                  );
                }

                else if (snapshot.hasError) {
                  _logger.e(snapshot.error);
                  return Text(snapshot.error.toString());
                }

                else {
                  return CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
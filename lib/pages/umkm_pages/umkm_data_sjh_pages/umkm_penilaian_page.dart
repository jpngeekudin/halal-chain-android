import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/helpers/typography_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';

class UmkmPenilaianPage extends StatefulWidget {
  const UmkmPenilaianPage({ Key? key }) : super(key: key);

  @override
  State<UmkmPenilaianPage> createState() => _UmkmPenilaianPageState();
}

class _UmkmPenilaianPageState extends State<UmkmPenilaianPage> {
  final _core = CoreService();
  bool _loading = false;

  final _dataPelaksanaanFormKey = GlobalKey<FormState>();
  final _teamMemberFormKey = GlobalKey<FormState>();
  final List<UmkmTeamAssignmentWithScore> _teamAssignment = [];
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _positionController = TextEditingController();
  final _nilaiController = TextEditingController();
  DateTime? _tanggalModel;
  final _tanggalController = TextEditingController();
  final _pemateriController = TextEditingController();

  void _showAssignmentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: ModalBottomSheetShape,
      builder: (context) {
        return getModalBottomSheetWrapper(
          context: context,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  getHeader(text: 'Tambah Anggota Tim', context: context),
                  Form(
                    key: _teamMemberFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getInputWrapper(
                          label: 'Nama',
                          input: TextFormField(
                            controller: _namaController,
                            decoration: getInputDecoration(label: 'Nama'),
                            style: inputTextStyle,
                            validator: validateRequired,
                          ),
                        ),
                        // getInputWrapper(
                        //   label: 'Jabatan',
                        //   input: TextFormField(
                        //     controller: _jabatanController,
                        //     decoration: getInputDecoration(label: 'Jabatan'),
                        //     style: inputTextStyle,
                        //     validator: validateRequired,
                        //   ),
                        // ),
                        getInputWrapper(
                          label: 'Posisi',
                          input: TextFormField(
                            controller: _positionController,
                            decoration: getInputDecoration(label: 'Posisi'),
                            style: inputTextStyle,
                            validator: validateRequired,
                          ),
                        ),
                        getInputWrapper(
                          label: 'Nilai',
                          input: TextFormField(
                            controller: _nilaiController,
                            decoration: getInputDecoration(label: 'Nilai'),
                            style: inputTextStyle,
                            validator: (valueStr) {
                              if (valueStr == null || valueStr.isEmpty) return 'Please fill this field!';
                              final value = int.parse(valueStr);
                              if (value < 0 || value > 100) return 'Please insert value between 0 to 100';
                              else return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.person_add_outlined, color: Colors.black),
                            SizedBox(width: 5),
                            Text('Tambah', style: TextStyle(
                              color: Colors.black
                            )),
                          ],
                        ),
                        onPressed: () {
                          final valid = _teamMemberFormKey.currentState!.validate();
                          if (!valid) return;
                          
                          if (
                            _namaController.text.isEmpty ||
                            // _jabatanController.text.isEmpty ||
                            _positionController.text.isEmpty ||
                            _nilaiController.text.isEmpty
                          ) return;

                          _addAssignment();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[200],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }

  void _addAssignment() {
    // final assignment = UmkmTeamAssignmentWithScore(
    //   _namaController.text,
    //   _jabatanController.text,
    //   _positionController.text,
    //   _nilaiController.text
    // );

    final assignment = UmkmTeamAssignmentWithScore(
      nama: _namaController.text,
      // jabatan: _jabatanController.text,
      position: _positionController.text,
      nilai: _nilaiController.text
    );

    setState(() => _teamAssignment.add(assignment));
    _namaController.text = '';
    _jabatanController.text = '';
    _positionController.text = '';
    _nilaiController.text = '';
  }

  _removeAssignment(UmkmTeamAssignmentWithScore assignment) {
    setState(() => _teamAssignment.remove(assignment));
  }

  void _submit() async {
    final valid = _dataPelaksanaanFormKey.currentState!.validate();
    if (!valid) return;

    if (_teamAssignment.isEmpty) {
      const snackBar = SnackBar(content: Text('Harap isi anggota team terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();
    final params = {
      'id': document!.id,
      'tanggal_pelaksanaan': _tanggalModel!.millisecondsSinceEpoch,
      'pemateri': _pemateriController.text,
      'data': _teamAssignment.map((ass) => ass.toJSON()).toList(),
    };
    
    try {
      setState(() => _loading = true);
      final response = await _core.genericPost(ApiList.umkmCreateBuktiPelaksanaan, null, params);
      const snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err, stacktrace) {
      print(stacktrace);
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
      appBar: AppBar(title: Text('Bukti Pelaksanaan'),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getHeader(
                  text: 'Data Bukti Pelaksanaan',
                  context: context
                ),
                SizedBox(height: 20),
                Form(
                  key: _dataPelaksanaanFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getInputWrapper(
                        label: 'Nama Pemateri',
                        input: TextFormField(
                          controller: _pemateriController,
                          decoration: getInputDecoration(label: 'Nama Pemateri'),
                          style: inputTextStyle,
                          validator: validateRequired,
                        ),
                      ),
                      getInputWrapper(
                        label: 'Tanggal Pelaksanaan',
                        input: TextFormField(
                          controller: _tanggalController,
                          decoration: getInputDecoration(label: 'Tanggal Pelaksanaan'),
                          style: inputTextStyle,
                          validator: validateRequired,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _tanggalController.text.isNotEmpty
                                ? defaultDateFormat.parse(_tanggalController.text)
                                : DateTime.now(),
                              firstDate: DateTime(2016),
                              lastDate: DateTime(2100),
                            );
                            
                            if (picked != null) {
                              _tanggalModel = picked;
                              _tanggalController.text = defaultDateFormat.format(picked);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                getHeader(
                  context: context,
                  text: 'Daftar Anggota Tim'
                ),
                ..._teamAssignment.map((ass) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )),
                            Text(ass.nama)
                          ],
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text('Jabatan', style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 12,
                        //     )),
                        //     Text(ass.jabatan)
                        //   ],
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Position', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )),
                            Text(ass.position)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nilai', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )),
                            Text(ass.nilai.toString())
                          ],
                        ),
                        InkWell(
                          child: Icon(Icons.close, color: Colors.red),
                          onTap: () => _removeAssignment(ass),
                        )
                      ],
                    ),
                  );
                }),
                if (_teamAssignment.isEmpty) Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: getPlaceholder(text: 'Belum ada anggota tim'),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.person_add_outlined, color: Colors.black),
                        SizedBox(width: 5),
                        Text('Tambah', style: TextStyle(
                          color: Colors.black
                        )),
                      ],
                    ),
                    onPressed: _showAssignmentModal,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Submit'),
                    onPressed: _submit,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
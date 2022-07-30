import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';

class UmkmTeamAssignPage extends StatefulWidget {
  const UmkmTeamAssignPage({ Key? key }) : super(key: key);

  @override
  State<UmkmTeamAssignPage> createState() => _UmkmTeamAssignPageState();
}

class _UmkmTeamAssignPageState extends State<UmkmTeamAssignPage> {
  final _core = CoreService();
  final _formKey = GlobalKey<FormState>();
  final List<UmkmTeamAssignment> _teamAssignment = [];
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _positionController = TextEditingController();

  bool _loading = false;

  void _openMemberModal() {
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Text('Tambah Anggota Team', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor
                  )),
                  SizedBox(height: 20),
                  getInputWrapper(
                    label: 'Nama',
                    input: TextFormField(
                      controller: _namaController,
                      decoration: getInputDecoration(label: 'Nama'),
                      style: inputTextStyle,
                      validator: validateRequired,
                    ),
                  ),
                  getInputWrapper(
                    label: 'Jabatan',
                    input: TextFormField(
                      controller: _jabatanController,
                      decoration: getInputDecoration(label: 'Jabatan'),
                      style: inputTextStyle,
                      validator: validateRequired,
                    ),
                  ),
                  getInputWrapper(
                    label: 'Posisi',
                    input: TextFormField(
                      controller: _positionController,
                      decoration: getInputDecoration(label: 'Posisi'),
                      style: inputTextStyle,
                      validator: validateRequired,
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
                          if (
                            _namaController.text.isEmpty ||
                            _jabatanController.text.isEmpty ||
                            _positionController.text.isEmpty
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
          ),
        );
      });
  }

  void _addAssignment() {
    final assignment = UmkmTeamAssignment(
      _namaController.text,
      _jabatanController.text,
      _positionController.text
    );

    setState(() => _teamAssignment.add(assignment));
    _namaController.text = '';
    _jabatanController.text = '';
    _positionController.text = '';
  }

  _removeAssignment(UmkmTeamAssignment assignment) {
    setState(() => _teamAssignment.remove(assignment));
  }

  void _submit() async {
    if (_teamAssignment.isEmpty) {
      const snackBar = SnackBar(content: Text('Harap isi anggota tim terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();

    final params = {
      'id': document!.id,
      'data': _teamAssignment.map((ass) => ass.toJSON()).toList(),
    };
    
    try {
      setState(() => _loading = true);
      final response = await _core.genericPost(ApiList.umkmCreatePenetapanTim, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data!'));
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
      appBar: AppBar(title: Text('Penetapan Team'),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Jabatan', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )),
                            Text(ass.jabatan)
                          ],
                        ),
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
                        InkWell(
                          child: Icon(Icons.close, color: Colors.red),
                          onTap: () => _removeAssignment(ass),
                        )
                      ],
                    ),
                  );
                }),
                if (_teamAssignment.isEmpty) Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Text('Belum ada anggota tim', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey[400]
                  )),
                ),
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
                    onPressed: _openMemberModal,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: _loading
                      ? CircularProgressIndicator()
                      : Text('Submit'),
                    onPressed: _loading ? null : _submit,
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
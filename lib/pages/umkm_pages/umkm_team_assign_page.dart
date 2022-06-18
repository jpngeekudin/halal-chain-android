import 'package:flutter/material.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';

class UmkmTeamAssignPage extends StatefulWidget {
  const UmkmTeamAssignPage({ Key? key }) : super(key: key);

  @override
  State<UmkmTeamAssignPage> createState() => _UmkmTeamAssignPageState();
}

class _UmkmTeamAssignPageState extends State<UmkmTeamAssignPage> {
  final _formKey = GlobalKey<FormState>();
  final List<UmkmTeamAssignment> _teamAssignment = [];
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _positionController = TextEditingController();

  void _addAssignment() {
    if (
      _namaController.text.isEmpty ||
      _jabatanController.text.isEmpty ||
      _positionController.text.isEmpty
    ) return;

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

  void _submit() {
    final params = {
      'id': '',
      'data': _teamAssignment.map((ass) => ass.toJSON()).toList(),
    };

    print(params);
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
                    onPressed: _addAssignment,
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
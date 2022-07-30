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
import 'package:logger/logger.dart';

class UmkmKebersihanPage extends StatefulWidget {
  const UmkmKebersihanPage({ Key? key }) : super(key: key);

  @override
  State<UmkmKebersihanPage> createState() => _UmkmKebersihanPageState();
}

class _UmkmKebersihanPageState extends State<UmkmKebersihanPage> {

  final List<UmkmKebersihan> _listKebersihan = [];

  DateTime? _tanggalModel;
  final _tanggalController = TextEditingController();
  final _penanggungjawabController = TextEditingController();
  bool _produksiModel = false;
  bool _gudangModel = false;
  bool _mesinModel = false;
  bool _kendaraanModel = false;

  final _titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold
  );

  void _showModalKebersihan() {
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
              child: StatefulBuilder(
                builder: (context, setFormState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      getHeader(
                        context: context,
                        text: 'Tambah Pengecekan Kebersihan'
                      ),
                      getInputWrapper(
                        label: 'Tanggal',
                        input: getInputDate(
                          label: 'Tanggal',
                          controller: _tanggalController,
                          context: context,
                          onChanged: (picked) {
                            setState(() => _tanggalModel = picked);
                          },
                        )
                      ),
                      getInputWrapper(
                        label: 'Penanggungjawab',
                        input: TextField(
                          controller: _penanggungjawabController,
                          decoration: getInputDecoration(label: 'Penanggungjawab'),
                          style: inputTextStyle,
                        )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Ruang Produksi'),
                          Switch(
                            value: _produksiModel,
                            onChanged: (value) {
                              setFormState(() => _produksiModel = value);
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Ruang Gudang'),
                          Switch(
                            value: _gudangModel,
                            onChanged: (value) {
                              setFormState(() => _gudangModel = value);
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Peralatan dan Mesin Produksi'),
                          Switch(
                            value: _mesinModel,
                            onChanged: (value) {
                              setFormState(() => _mesinModel = value);
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Kebersihan Kendaraan'),
                          Switch(
                            value: _kendaraanModel,
                            onChanged: (value) {
                              setFormState(() => _kendaraanModel = value);
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_tanggalModel == null || _penanggungjawabController.text.isEmpty) {
                                final snackBar = SnackBar(content: Text('Harap isi semua field yang dibutuhkan'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                return;
                              }

                              _addKebersihan();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[200]
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.add_circle, color: Colors.black),
                                SizedBox(width: 10),
                                Text('Tambah', style: TextStyle(
                                  color: Colors.black
                                ))
                              ],
                            )
                          )
                        ],
                      ),
                    ],
                  );
                }
              ),
            )
          )
        );
      }
    );
  }

  Widget _getKebersihanCard(UmkmKebersihan kebersihan) {
    final _labelTextStyle = TextStyle(
      color: Colors.grey[600]
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(defaultDateFormat.format(kebersihan.tanggal), style: TextStyle(
                  fontWeight: FontWeight.bold
                )),
                SizedBox(height: 10),
                Wrap(
                  children: [
                    Text('Penanggungjawab', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(kebersihan.penanggungjawab)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Ruang Produksi', style: _labelTextStyle),
                    SizedBox(width: 10),
                    if (kebersihan.produksi) Icon(Icons.check, color: Colors.green)
                    else Icon(Icons.close, color: Colors.red)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Ruang Gudang', style: _labelTextStyle),
                    SizedBox(width: 10),
                    if (kebersihan.gudang) Icon(Icons.check, color: Colors.green)
                    else Icon(Icons.close, color: Colors.red)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Peralatan dan Mesin', style: _labelTextStyle),
                    SizedBox(width: 10),
                    if (kebersihan.mesin) Icon(Icons.check, color: Colors.green)
                    else Icon(Icons.close, color: Colors.red)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Kendaraan', style: _labelTextStyle),
                    SizedBox(width: 10),
                    if (kebersihan.kendaraan) Icon(Icons.check, color: Colors.green)
                    else Icon(Icons.close, color: Colors.red)
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _removeKebersihan(kebersihan),
            child: Text('Remove'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red
            )
          )
        ],
      ),
    );
  }

  void _addKebersihan() {
    final kebersihan = UmkmKebersihan(
      tanggal: _tanggalModel!,
      produksi: _produksiModel,
      gudang: _gudangModel,
      mesin: _mesinModel,
      kendaraan: _kendaraanModel,
      penanggungjawab: _penanggungjawabController.text
    );

    setState(() {
      _listKebersihan.add(kebersihan);
      _tanggalModel = null;
      _tanggalController.text = '';
      _penanggungjawabController.text = '';
      _produksiModel = false;
      _gudangModel = false;
      _mesinModel = false;
      _kendaraanModel = false;
    });
  }

  void _removeKebersihan(UmkmKebersihan kebersihan) {
    setState(() => _listKebersihan.remove(kebersihan));
  }

  void _submit() async {
    if (_listKebersihan.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap isi daftar pengecekan kebersihan terlebih dahulu.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();
    final params = {
      'id': document!.id,
      'data': _listKebersihan.map((kebersihan) => {
        'tanggal': kebersihan.tanggal.millisecondsSinceEpoch,
        'produksi': kebersihan.produksi,
        'gudang': kebersihan.gudang,
        'mesin': kebersihan.mesin,
        'kendaraan': kebersihan.kendaraan,
        'penanggungjawab': kebersihan.penanggungjawab
      }).toList(),
    };
    
    try {
      final core = CoreService();
      final response = await core.genericPost(ApiList.umkmFormKebersihan, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengecekan Kebersihan Fasilitas Produksi dan Kendaraan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Daftar Pengecekan Kebersihan', style: _titleTextStyle),
                    TextButton(
                      child:  Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.add_circle),
                          SizedBox(width: 10),
                          Text('Tambah')
                        ],
                      ),
                      onPressed: _showModalKebersihan,
                    )
                  ],
                ),
                SizedBox(height: 10),
                if (_listKebersihan.isEmpty) Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: getPlaceholder(text: 'Belum ada list pengecekan kebersihan'),
                )
                else ..._listKebersihan.map((kebersihan) => _getKebersihanCard(kebersihan)).toList(),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Submit'),
                    onPressed: (() => _submit()),
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
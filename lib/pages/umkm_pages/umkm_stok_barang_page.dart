import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmStokBarangPage extends StatefulWidget {
  const UmkmStokBarangPage({ Key? key }) : super(key: key);

  @override
  State<UmkmStokBarangPage> createState() => _UmkmStokBarangPageState();
}

class _UmkmStokBarangPageState extends State<UmkmStokBarangPage> {
  final List<UmkmStokBarang> _listStok = [];
  
  DateTime? _tanggalBeliModel;
  final _tanggalBeliController = TextEditingController();
  final _namaBahanController = TextEditingController();
  final _jumlahBahanController = TextEditingController();
  final _jumlahKeluarController = TextEditingController();
  final _stokSisaController = TextEditingController();
  bool _parafModel = false;
  
  final _titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16
  );

  Widget _getStokCard(UmkmStokBarang stok) {
    final _labelTextStyle = TextStyle(
      color: Colors.grey[400]
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stok.namaBahan, style: TextStyle(
                  fontWeight: FontWeight.bold
                )),
                SizedBox(height: 10),
                Wrap(
                  children: [
                    Text('Pembelian', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(defaultDateFormat.format(stok.tanggalBeli))
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Bahan Masuk', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(stok.jumlahBahan)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Bahan Keluar', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(stok.jumlahKeluar)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Sisa', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(stok.stokSisa)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Paraf', style: _labelTextStyle),
                    SizedBox(width: 10),
                    if (stok.paraf) Icon(Icons.check, color: Colors.green)
                    else Icon(Icons.close, color: Colors.red)
                  ],
                )
              ],
            ),
          ),
          ElevatedButton(
            child: Text('Remove'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red
            ),
            onPressed: () => _removeStok(stok),
          )
        ],
      ),
    );
  }

  void _addStok() {
    if (
      _tanggalBeliModel == null ||
      _namaBahanController.text.isEmpty ||
      _jumlahBahanController.text.isEmpty ||
      _jumlahKeluarController.text.isEmpty ||
      _stokSisaController.text.isEmpty
    ) {
      final snackBar = SnackBar(content: Text('Harap isi semua field yang diperlukan'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final stok = UmkmStokBarang(
      tanggalBeli: _tanggalBeliModel!,
      namaBahan: _namaBahanController.text,
      jumlahBahan: _jumlahBahanController.text,
      jumlahKeluar: _jumlahKeluarController.text,
      stokSisa: _stokSisaController.text,
      paraf: _parafModel
    );
    
    setState(() => _listStok.add(stok));
    _tanggalBeliModel = null;
    _tanggalBeliController.text = '';
    _namaBahanController.text = '';
    _jumlahBahanController.text = '';
    _jumlahKeluarController.text = '';
    _stokSisaController.text = '';
    _parafModel = false;
  }

  void _removeStok(UmkmStokBarang stok) {
    setState(() => _listStok.remove(stok));
  }

  void _submit() async {
    if (_listStok.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap isi sisa stok terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();
    final params = {
      'id': document!.id,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'data': _listStok.map((stok) => {
        'tanggal_beli': stok.tanggalBeli.millisecondsSinceEpoch,
        'nama_bahan': stok.namaBahan,
        'jumlah_bahan': stok.jumlahBahan,
        'jumlah_keluar': stok.jumlahKeluar,
        'stok_sisa': stok.stokSisa,
        'paraf': stok.paraf
      }).toList(),
    };
    
    try {
      final core = CoreService();
      final response = await core.genericPost(ApiList.umkmCreateFormStokBarang, null, params);
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
        title: Text('Stok Bahan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Stok Bahan', style: _titleTextStyle),
                SizedBox(height: 10),
                if (_listStok.isEmpty) Text('Belum ada stok bahan')
                else ..._listStok.map((stok) => _getStokCard(stok)).toList(),
                SizedBox(height: 30),

                Text('Tambah Stok Bahan', style: _titleTextStyle),
                SizedBox(height: 10),
                getInputWrapper(
                  label: 'Nama Bahan',
                  input: TextField(
                    controller: _namaBahanController,
                    decoration: getInputDecoration(label: 'Nama Bahan'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Tanggal Pembelian',
                  input: TextFormField(
                    controller: _tanggalBeliController,
                    decoration: getInputDecoration(label: 'Tanggal Pembelian'),
                    style: inputTextStyle,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _tanggalBeliModel ?? DateTime.now(),
                        firstDate: DateTime(2016),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() => _tanggalBeliModel = picked);
                        _tanggalBeliController.text = defaultDateFormat.format(picked);
                      }
                    },
                  ),
                ),
                getInputWrapper(
                  label: 'Jumlah Bahan Masuk',
                  input: TextField(
                    controller: _jumlahBahanController,
                    decoration: getInputDecoration(label: 'Jumlah Bahan Masuk'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Jumlah Bahan Keluar',
                  input: TextField(
                    controller: _jumlahKeluarController,
                    decoration: getInputDecoration(label: 'Jumlah Bahan Keluar'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Sisa Stok',
                  input: TextField(
                    controller: _stokSisaController,
                    decoration: getInputDecoration(label: 'Sisa Stok'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Paraf',
                  input: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Switch(
                        value: _parafModel,
                        onChanged: (value) {
                          setState(() => _parafModel = value);
                        },
                      )
                    ],
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addStok(),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Tambah', style: TextStyle(
                            color: Colors.black
                          ))
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[200]
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Subtmit'),
                    onPressed: () => _submit(),
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
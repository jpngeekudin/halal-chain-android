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

class UmkmPemusnahanPage extends StatefulWidget {
  const UmkmPemusnahanPage({ Key? key }) : super(key: key);

  @override
  State<UmkmPemusnahanPage> createState() => _UmkmPemusnahanPageState();
}

class _UmkmPemusnahanPageState extends State<UmkmPemusnahanPage> {

  final List<UmkmPemusnahan> _listPemusnahan = [];

  DateTime? _tanggalProduksiModel;
  final _tanggalProduksiController = TextEditingController();
  DateTime? _tanggalPemusnahanModel;
  final _tanggalPemusnahanController = TextEditingController();
  final _namaProdukController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _penyebabController = TextEditingController();
  final _penanggungjawabController = TextEditingController();

  final _titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16
  );

  void _showModalPemusnahan() {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  getHeader(
                    context: context,
                    text: 'Tambah Pemusnahan'
                  ),
                  getInputWrapper(
                    label: 'Nama Produk',
                    input: TextField(
                      controller: _namaProdukController,
                      decoration: getInputDecoration(label: 'Nama Produk'),
                      style: inputTextStyle,
                    )
                  ),
                  getInputWrapper(
                    label: 'Tanggal Produksi',
                    input: getInputDate(
                      label: 'Tanggal Produksi',
                      controller: _tanggalProduksiController,
                      context: context,
                      onChanged: (picked) {
                        setState(() => _tanggalProduksiModel = picked);
                      },
                    )
                  ),
                  getInputWrapper(
                    label: 'Jumlah',
                    input: TextField(
                      controller: _jumlahController,
                      decoration: getInputDecoration(label: 'Jumlah'),
                      style: inputTextStyle,
                    )
                  ),
                  getInputWrapper(
                    label: 'Penyebab',
                    input: TextField(
                      controller: _penyebabController,
                      decoration: getInputDecoration(label: 'Penyebab'),
                      style: inputTextStyle,
                    )
                  ),
                  getInputWrapper(
                    label: 'Tanggal Pemusnahan',
                    input: getInputDate(
                      label: 'Tanggal Pemusnahan',
                      controller: _tanggalPemusnahanController,
                      context: context,
                      onChanged: (picked) {
                        setState(() => _tanggalPemusnahanModel = picked);
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (
                            _tanggalProduksiModel == null ||
                            _tanggalPemusnahanModel == null ||
                            _namaProdukController.text.isEmpty ||
                            _jumlahController.text.isEmpty ||
                            _penyebabController.text.isEmpty ||
                            _penanggungjawabController.text.isEmpty
                          ) {
                            final snackBar = SnackBar(content: Text('Harap isi seluruh field yang dibutuhkan!'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }

                          _addPemusnahan();
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
              ),
            ),
          )
        );
      }
    );
  }

  Widget _getPemusnahanCard(UmkmPemusnahan pemusnahan) {
    final _labelTextStyle = TextStyle(
      color: Colors.grey[500]
    );

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pemusnahan.namaProduk, style: TextStyle(
                  fontWeight: FontWeight.bold
                )),
                SizedBox(height: 10),
                Wrap(
                  children: [
                    Text('Produksi', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(defaultDateFormat.format(pemusnahan.tanggalProduksi))
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Jumlah', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(pemusnahan.jumlah)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Penyebab', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(pemusnahan.penyebab)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Pemusnahan', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(defaultDateFormat.format(pemusnahan.tanggalPemusnahan))
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Penanggungjawab', style: _labelTextStyle),
                    SizedBox(width: 10),
                    Text(pemusnahan.penanggungjawab)
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red
            ),
            child: Text('Remove'),
            onPressed: () => _removePemusnahan(pemusnahan),
          )
        ],
      ),
    );
  }

  void _addPemusnahan() {
    final pemusnahan = UmkmPemusnahan(
      namaProduk: _namaProdukController.text,
      jumlah: _jumlahController.text,
      penyebab: _penyebabController.text,
      penanggungjawab: _penanggungjawabController.text,
      tanggalPemusnahan: _tanggalPemusnahanModel!,
      tanggalProduksi: _tanggalProduksiModel!
    );

    setState(() => _listPemusnahan.add(pemusnahan));
    _tanggalProduksiModel = null;
    _tanggalProduksiController.text = '';
    _tanggalPemusnahanModel = null;
    _tanggalPemusnahanController.text = '';
    _namaProdukController.text = '';
    _jumlahController.text = '';
    _penyebabController.text = '';
    _penanggungjawabController.text = '';
  }

  void _removePemusnahan(UmkmPemusnahan pemusnahan) {
    setState(() => _listPemusnahan.remove(pemusnahan));
  }

  void _submit() async {
    if (_listPemusnahan.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap isi list pemusnahan terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();
    final params = {
      'id': document!.id,
      'data': _listPemusnahan.map((pemusnahan) => {
        'tanggal_produksi': pemusnahan.tanggalProduksi.millisecondsSinceEpoch,
        'tanggal_pemusnahan': pemusnahan.tanggalPemusnahan.millisecondsSinceEpoch,
        'nama_produk': pemusnahan.namaProduk,
        'jumlah': pemusnahan.jumlah,
        'penyebab': pemusnahan.penyebab,
        'penanggungjawab': pemusnahan.penanggungjawab
      }).toList()
    };
    
    try {
      final core = CoreService();
      final response = await core.genericPost(ApiList.umkmCreateFormPemusnahan, null, params);
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
        title: Text('Pemusnahan Barang / Produk'),
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
                    Text('Daftar Pemusnahan', style: _titleTextStyle),
                    TextButton(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.add_circle),
                          SizedBox(width: 10),
                          Text('Tambah')
                        ],
                      ),
                      onPressed: _showModalPemusnahan,
                    )
                  ],
                ),
                SizedBox(height: 10),
                if (_listPemusnahan.isEmpty) Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: getPlaceholder(text: 'Belum ada daftar pemusnahan'),
                )
                else ..._listPemusnahan.map((pemusnahan) => _getPemusnahanCard(pemusnahan)).toList(),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _submit(),
                    child: Text('Submit'),
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
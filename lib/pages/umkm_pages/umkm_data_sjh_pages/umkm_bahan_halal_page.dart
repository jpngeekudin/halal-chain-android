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
import 'package:halal_chain/models/bahan_halal_opt_model.dart';
import 'package:logger/logger.dart';

class UmkmBahanHalalPage extends StatefulWidget {
  const UmkmBahanHalalPage({Key? key}) : super(key: key);

  @override
  State<UmkmBahanHalalPage> createState() => _UmkmBahanHalalPageState();
}

class _UmkmBahanHalalPageState extends State<UmkmBahanHalalPage> {
  final _titleTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  final List<UmkmBahanHalal> _listBahan = [];

  // final _namaMerkController = TextEditingController();
  BahanHalalOpts? _namaMerkModel;
  final _namaBahanLainnya = TextEditingController();
  final _namaNegaraController = TextEditingController();
  final _pemasokController = TextEditingController();
  final _penerbitController = TextEditingController();
  final _nomorController = TextEditingController();
  final _masaBerlakuController = TextEditingController();
  DateTime? _masaBerlakuModel;
  final _dokumenLainController = TextEditingController();
  final _keteranganController = TextEditingController();

  List<BahanHalalOpts> _bahanHalalOpts = [];

  @override
  void initState() {
    super.initState();
    _getBahanOpts();
  }

  Future<void> _getBahanOpts() async {
    try {
      final core = CoreService();
      final res = await core.genericGet(ApiList.utilListBahanHalal);
      setState(() {
        _bahanHalalOpts = [
          ...res.data,
          {'_id': 'other', 'name': 'other', 'required': false}
        ]
            .where((e) => e['name'] != null)
            .map<BahanHalalOpts>((d) => BahanHalalOpts.fromJSON(d))
            .toList();
      });
    } catch (err, trace) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'];

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text(message),
              ));

      rethrow;
    }
  }

  void _showModalBahan() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: ModalBottomSheetShape,
        builder: (context) {
          return getModalBottomSheetWrapper(
              context: context,
              child: StatefulBuilder(builder: (context, setStateForm) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        getHeader(context: context, text: 'Tambah Bahan Halal'),
                        getInputWrapper(
                            label: 'Nama / Merk / Kode Bahan',
                            // input: TextField(
                            //   controller: _namaMerkController,
                            //   decoration: getInputDecoration(
                            //       label: 'Nama / Merk / Kode Bahan'),
                            //   style: inputTextStyle,
                            // )),
                            input: DropdownButtonFormField(
                              items: _bahanHalalOpts
                                  .map((opt) => DropdownMenuItem(
                                        value: opt,
                                        child: Text(opt.name),
                                      ))
                                  .toList(),
                              onChanged: (BahanHalalOpts? value) {
                                // _namaMerkController.text = value as String;
                                setStateForm(() {
                                  _namaMerkModel = value;
                                });
                              },
                              decoration: getInputDecoration(
                                  label: 'Nama / Merk / Kode Bahan'),
                              isDense: true,
                              // value: _namaMerkController.text,
                            )),
                        if (_namaMerkModel?.id == 'other')
                          getInputWrapper(
                              label: 'Nama Barang Lainnya',
                              input: TextField(
                                controller: _namaBahanLainnya,
                                decoration: getInputDecoration(
                                    label: 'Nama Barang Lainnya'),
                                style: inputTextStyle,
                              )),
                        getInputWrapper(
                            label: 'Nama dan Negara Produsen',
                            input: TextField(
                              controller: _namaNegaraController,
                              decoration: getInputDecoration(
                                  label: 'Nama / Merk / Kode Bahan'),
                              style: inputTextStyle,
                            )),
                        getInputWrapper(
                            label: 'Pemasok',
                            input: TextField(
                              controller: _pemasokController,
                              decoration: getInputDecoration(label: 'Pemasok'),
                              style: inputTextStyle,
                            )),
                        if (_namaMerkModel?.requireCert ?? false) ...[
                          getInputWrapper(
                              label: 'Lembaga Penerbit Sertifikat Halal',
                              input: TextField(
                                controller: _penerbitController,
                                decoration: getInputDecoration(
                                    label: 'Lembaga Penerbit'),
                                style: inputTextStyle,
                              )),
                          getInputWrapper(
                              label: 'Nomor Sertifikat Halal',
                              input: TextField(
                                controller: _nomorController,
                                decoration: getInputDecoration(
                                    label: 'Nomor Sertifikat Halal'),
                                style: inputTextStyle,
                              )),
                          getInputWrapper(
                              label: 'Masa Berlaku Sertifikat Halal',
                              input: getInputDate(
                                  label: 'Masa Berlaku Sertifikat Halal',
                                  controller: _masaBerlakuController,
                                  context: context,
                                  onChanged: (value) {
                                    setState(() => _masaBerlakuModel = value);
                                  })),
                        ],
                        getInputWrapper(
                            label: 'Dokumen Lain',
                            input: TextField(
                              controller: _dokumenLainController,
                              decoration:
                                  getInputDecoration(label: 'Dokumen Lain'),
                              style: inputTextStyle,
                            )),
                        getInputWrapper(
                            label: 'Keterangan',
                            input: TextField(
                              controller: _keteranganController,
                              decoration:
                                  getInputDecoration(label: 'Keterangan'),
                              style: inputTextStyle,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  bool conditionCert = _namaMerkModel
                                              ?.requireCert ??
                                          false
                                      ? (_penerbitController.text.isNotEmpty &&
                                          _nomorController.text.isNotEmpty &&
                                          _masaBerlakuController
                                              .text.isNotEmpty &&
                                          _masaBerlakuModel != null)
                                      : true;

                                  if (_namaMerkModel == null ||
                                      _namaNegaraController.text.isEmpty ||
                                      _pemasokController.text.isEmpty ||
                                      !conditionCert ||
                                      _dokumenLainController.text.isEmpty ||
                                      _keteranganController.text.isEmpty) {
                                    final snackBar = SnackBar(
                                        content: Text(
                                            'Harap isi seluruh field yang dibutuhkan'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    return;
                                  }

                                  _addBahan();
                                  Navigator.of(context).pop();
                                },
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle, color: Colors.black),
                                    SizedBox(width: 10),
                                    Text('Tambah',
                                        style: TextStyle(color: Colors.black))
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.grey[200]))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }));
        });
  }

  Widget _getBahanCard(UmkmBahanHalal bahan) {
    final _labelTextStyle = TextStyle(color: Colors.grey[600]);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bahan.namaMerk,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                children: [
                  Text('Nama dan Negara Produsen', style: _labelTextStyle),
                  SizedBox(width: 10),
                  Text(bahan.namaNegara)
                ],
              ),
              SizedBox(height: 5),
              Wrap(
                children: [
                  Text('Pemasok', style: _labelTextStyle),
                  SizedBox(width: 10),
                  Text(bahan.pemasok)
                ],
              ),
              SizedBox(height: 5),
              Wrap(
                children: [
                  Text('Lembaga Penerbit', style: _labelTextStyle),
                  SizedBox(width: 10),
                  Text(bahan.penerbit)
                ],
              ),
              SizedBox(height: 5),
              Wrap(
                children: [
                  Text('Nomor', style: _labelTextStyle),
                  SizedBox(width: 10),
                  Text(bahan.nomor)
                ],
              ),
              SizedBox(height: 5),
              Wrap(
                children: [
                  Text('Masa Berlaku', style: _labelTextStyle),
                  SizedBox(width: 10),
                  Text(bahan.masaBerlaku != null
                      ? defaultDateFormat.format(bahan.masaBerlaku!)
                      : 'Null')
                ],
              ),
              SizedBox(height: 5),
              Wrap(
                children: [
                  Text('Dokumen Lain', style: _labelTextStyle),
                  SizedBox(width: 10),
                  Text(bahan.dokumenLain)
                ],
              ),
              SizedBox(height: 5),
              Wrap(
                children: [
                  Text('Keterangan', style: _labelTextStyle),
                  SizedBox(width: 10),
                  Text(bahan.keterangan)
                ],
              ),
            ],
          )),
          ElevatedButton(
            child: Text('Remove'),
            onPressed: () => _removeBahan(bahan),
            style: ElevatedButton.styleFrom(primary: Colors.red),
          )
        ],
      ),
    );
  }

  void _addBahan() {
    String namaMerk = _namaMerkModel!.id == 'other'
        ? _namaBahanLainnya.text
        : _namaMerkModel!.name;

    final bahan = UmkmBahanHalal(
        // namaMerk: _namaMerkController.text,
        namaMerk: namaMerk,
        namaNegara: _namaNegaraController.text,
        pemasok: _pemasokController.text,
        penerbit: _penerbitController.text,
        nomor: _nomorController.text,
        masaBerlaku: _masaBerlakuModel,
        dokumenLain: _dokumenLainController.text,
        keterangan: _keteranganController.text);

    setState(() {
      _listBahan.add(bahan);
      // _namaMerkController.text = '';
      _namaMerkModel = null;
      _namaNegaraController.text = '';
      _pemasokController.text = '';
      _penerbitController.text = '';
      _nomorController.text = '';
      _masaBerlakuController.text = '';
      _masaBerlakuModel = null;
      _dokumenLainController.text = '';
      _keteranganController.text = '';
    });
  }

  void _removeBahan(UmkmBahanHalal bahan) {
    setState(() => _listBahan.remove(bahan));
  }

  void _submit() async {
    if (_listBahan.isEmpty) {
      final snackBar = SnackBar(
          content: Text('Harap isi daftar bahan halal terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();
    final params = {
      'id': document!.id,
      'data': _listBahan
          .map((bahan) => {
                'nama_merk': bahan.namaMerk,
                'nama_negara': bahan.namaNegara,
                'pemasok': bahan.pemasok,
                'penerbit': bahan.penerbit,
                'nomor': bahan.nomor,
                'masa_berlaku': bahan.masaBerlaku?.millisecondsSinceEpoch,
                'dokumen_lain': bahan.dokumenLain,
                'keterangan': bahan.keterangan
              })
          .toList()
    };

    try {
      final core = CoreService();
      final response =
          await core.genericPost(ApiList.umkmBarangHalal, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (err) {
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Bahan Halal')),
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
                    Text('Daftar Bahan Halal', style: _titleTextStyle),
                    TextButton(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.add_circle),
                          SizedBox(width: 10),
                          Text('Tambah')
                        ],
                      ),
                      onPressed: _showModalBahan,
                    )
                  ],
                ),
                SizedBox(height: 10),
                if (_listBahan.isEmpty)
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: getPlaceholder(text: 'Belum ada daftar bahan halal'),
                  )
                else
                  ..._listBahan.map((bahan) => _getBahanCard(bahan)).toList(),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Submit'),
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

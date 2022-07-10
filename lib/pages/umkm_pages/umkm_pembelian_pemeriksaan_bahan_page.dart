import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/helpers/utils_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';
import 'package:signature/signature.dart';

class UmkmPembelianPemerikasaanBahanPage extends StatefulWidget {
  const UmkmPembelianPemerikasaanBahanPage({ Key? key, this.typeBahan = 'non-import' }) : super(key: key);
  final String typeBahan;

  @override
  State<UmkmPembelianPemerikasaanBahanPage> createState() => _UmkmPembelianPemerikasaanBahanPageState();
}

class _UmkmPembelianPemerikasaanBahanPageState extends State<UmkmPembelianPemerikasaanBahanPage> {
  List<UmkmPembelianPemeriksaanBahan> _listBahan = [];
  
  final _tanggalController = TextEditingController();
  DateTime? _tanggalModel;
  final _namaMerkBahanController = TextEditingController();
  final _namaNegaraProdusen = TextEditingController();
  bool _adaDiDaftarBahanHalalModel = false;
  final _expDateBahanController = TextEditingController();
  DateTime? _expDateBahanModel;
  final _parafController = SignatureController(
    penStrokeWidth: 5,
  );

  final _titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  void _addBahan() async {
    if (
      _tanggalModel == null ||
      _namaMerkBahanController.text.isEmpty ||
      _namaNegaraProdusen.text.isEmpty ||
      _expDateBahanModel == null ||
      _parafController.isEmpty
    ) {
      final snackBar = SnackBar(content: Text('Harap isi semua field yang dibutuhkan'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final parafBytes = await _parafController.toPngBytes();

    final bahan = UmkmPembelianPemeriksaanBahan(
      tanggal: _tanggalModel!,
      expDateBahan: _expDateBahanModel!,
      namaMerkBahan: _namaMerkBahanController.text,
      namaNegaraProdusen: _namaNegaraProdusen.text,
      adaDiDaftarBahanHalal: _adaDiDaftarBahanHalalModel,
      paraf: await uint8ListToFile(parafBytes!),
    );

    setState(() => _listBahan.add(bahan));
    _tanggalModel = null;
    _tanggalController.text = '';
    _expDateBahanModel = null;
    _expDateBahanController.text = '';
    _namaMerkBahanController.text = '';
    _namaNegaraProdusen.text = '';
    _adaDiDaftarBahanHalalModel = false;
    _parafController.clear();
  }

  void _removeBahan(UmkmPembelianPemeriksaanBahan bahan) {
    setState(() => _listBahan.remove(bahan));
  }
  
  void _submit() async {
    if (_listBahan.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap isi daftar bahan terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final core = CoreService();
    final logger = Logger();

    try {
      for (int i = 0; i < _listBahan.length; i++) {
        final bahan = _listBahan[i];
        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            bahan.paraf.path,
            filename: bahan.paraf.path.split('/').last
          )
        });
        final upload = await core.genericPost(ApiList.imageUpload, null, formData);
        bahan.setParafUrl(upload.data);
      }

      final document = await getUmkmDocument();
      final params = {
        'id': document!.id,
        'data': _listBahan.map((bahan) => {
          'Tanggal': bahan.tanggal.millisecondsSinceEpoch,
          'nama_dan_merk': bahan.namaMerkBahan,
          'nama_dan_negara': bahan.namaNegaraProdusen,
          'halal': bahan.adaDiDaftarBahanHalal,
          'exp_bahan': bahan.expDateBahan.millisecondsSinceEpoch,
          'paraf': bahan.parafUploadedUrl
        }).toList()
      };

      String url;
      if (widget.typeBahan == 'non-import') url = ApiList.umkmCreateFormPembelianPemeriksaan;
      else url = ApiList.umkmCreateFormPembelianPemeriksaanImport;
      final response = await core.genericPost(url, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    catch(err, stacktrace) {
      logger.e(stacktrace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _getBahanCard(UmkmPembelianPemeriksaanBahan bahan) {
    final labelTextStyle = TextStyle(
      color: Colors.grey[400]
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
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
                Text(bahan.namaMerkBahan, style: TextStyle(
                  fontWeight: FontWeight.bold
                )),
                SizedBox(height: 10),
                Wrap(
                  children: [
                    Text('Produsen', style: labelTextStyle),
                    SizedBox(width: 10),
                    Text(bahan.namaNegaraProdusen)
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Beli', style: labelTextStyle),
                    SizedBox(width: 10),
                    Text(defaultDateFormat.format(bahan.tanggal))
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Kadaluarsa', style: labelTextStyle),
                    SizedBox(width: 10),
                    Text(defaultDateFormat.format(bahan.expDateBahan))
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Ada di Daftar Halal', style: labelTextStyle),
                    SizedBox(width: 10),
                    Text(bahan.adaDiDaftarBahanHalal ? 'Ya' : 'Tidak')
                  ],
                ),
                SizedBox(height: 5),
                // Wrap(
                //   crossAxisAlignment: WrapCrossAlignment.center,
                //   children: [
                //     Text('Paraf', style: labelTextStyle),
                //     SizedBox(width: 10),
                //     bahan.paraf
                //       ? Icon(Icons.check, color: Colors.green)
                //       : Icon(Icons.close, color: Colors.red)
                //   ],
                // )
              ],
            ),
          ),
          ElevatedButton(
            child: Text('Remove'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red
            ),
            onPressed: () => _removeBahan(bahan),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.typeBahan != 'import'
          ? 'Pembelian dan Pemeriksaan Bahan'
          : 'Pembelian dan Pemeriksaan Bahan Import'
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.typeBahan != 'import'
                  ? 'List Bahan'
                  : 'List Bahan Import',
                  style: _titleTextStyle
                ),
                SizedBox(height: 10),
                if (_listBahan.isNotEmpty) ..._listBahan.map((bahan) => _getBahanCard(bahan)).toList()
                else Text('Belum ada list bahan.'),
                SizedBox(height: 30),

                Text('Tambah Bahan', style: _titleTextStyle),
                SizedBox(height: 10),
                getInputWrapper(
                  label: 'Tanggal Datang / Dibeli',
                  input: TextFormField(
                    controller: _tanggalController,
                    decoration: getInputDecoration(label: 'Tanggal Datang / Dibeli'),
                    style: inputTextStyle,
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
                        setState(() => _tanggalModel = picked);
                        _tanggalController.text = defaultDateFormat.format(picked);
                      }
                    },
                  ),
                ),
                getInputWrapper(
                  label: 'Nama / Merk Bahan',
                  input: TextField(
                    controller: _namaMerkBahanController,
                    decoration: getInputDecoration(label: 'Nama / Merk Bahan'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Nama & Negara Produsen',
                  input: TextField(
                    controller: _namaNegaraProdusen,
                    decoration: getInputDecoration(label: 'Nama & Negara Produsen'),
                    style: inputTextStyle,
                  )
                ),
                getInputWrapper(
                  label: 'Ada di Daftar Bahan Halal',
                  input: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Switch(
                        value: _adaDiDaftarBahanHalalModel,
                        onChanged: (value) {
                          setState(() => _adaDiDaftarBahanHalalModel = value);
                        },
                      ),
                      SizedBox(width: 10),
                      Text(_adaDiDaftarBahanHalalModel ? 'Ya' : 'Tidak')
                    ],
                  )
                ),
                getInputWrapper(
                  label: 'Exp. Date Bahan',
                  input: TextFormField(
                    controller: _expDateBahanController,
                    decoration: getInputDecoration(label: 'Exp. Date Bahan'),
                    style: inputTextStyle,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _expDateBahanController.text.isNotEmpty
                          ? defaultDateFormat.parse(_expDateBahanController.text)
                          : DateTime.now(),
                        firstDate: DateTime(2016),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() => _expDateBahanModel = picked);
                        _expDateBahanController.text = defaultDateFormat.format(picked);
                      }
                    },
                  ),
                ),
                getInputWrapper(
                  label: 'Paraf',
                  // input: Wrap(
                  //   crossAxisAlignment: WrapCrossAlignment.center,
                  //   children: [
                  //     Switch(
                  //       value: _parafModel,
                  //       onChanged: (value) {
                  //         setState(() => _parafModel = value);
                  //       },
                  //     ),
                  //     SizedBox(width: 10),
                  //     Text(_parafModel ? 'Ya' : 'Tidak')
                  //   ],
                  // ),
                  input: getInputSignature(
                    controller: _parafController,
                    context: context
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
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
                        primary: Colors.grey[200],
                      ),
                      onPressed: () => _addBahan(),
                    )
                  ],
                ),
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
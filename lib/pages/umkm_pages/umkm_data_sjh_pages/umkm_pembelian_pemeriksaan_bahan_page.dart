import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/helpers/typography_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/helpers/utils_helper.dart';
import 'package:halal_chain/models/signature_model.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/signature_form_widget.dart';
import 'package:logger/logger.dart';
import 'package:signature/signature.dart';
import 'package:halal_chain/models/bahan_halal_opt_model.dart';

class UmkmPembelianPemerikasaanBahanPage extends StatefulWidget {
  const UmkmPembelianPemerikasaanBahanPage(
      {Key? key, this.typeBahan = 'non-import'})
      : super(key: key);
  final String typeBahan;

  @override
  State<UmkmPembelianPemerikasaanBahanPage> createState() =>
      _UmkmPembelianPemerikasaanBahanPageState();
}

class _UmkmPembelianPemerikasaanBahanPageState
    extends State<UmkmPembelianPemerikasaanBahanPage> {
  List<UmkmPembelianPemeriksaanBahan> _listBahan = [];

  final _tanggalController = TextEditingController();
  DateTime? _tanggalModel;
  // final _namaMerkBahanController = TextEditingController();
  BahanHalalOpts? _namaMerkBahanModel;
  final _namaBahanLainnya = TextEditingController();
  final _namaNegaraProdusen = TextEditingController();
  bool _adaDiDaftarBahanHalalModel = false;
  final _jumlahPembelianController = TextEditingController();
  final _expDateBahanController = TextEditingController();
  final _noSertifikatController = TextEditingController();
  File? _strukPembelianModel;
  DateTime? _expDateBahanModel;
  UserSignature? _parafModel;
  // final _parafController = SignatureController(
  //   penStrokeWidth: 5,
  // );

  final _titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  List<BahanHalalOpts> _bahanHalalOpts = [];

  @override
  void initState() {
    super.initState();
    _getBahanOpts();
  }

  Future<void> _getBahanOpts() async {
    try {
      final logger = Logger();
      final core = CoreService();
      final res = await core.genericGet(ApiList.utilListBahanHalal);
      setState(() {
        _bahanHalalOpts = [
          ...res.data,
          {'_id': 'other', 'name': 'Lainnya', 'required': false}
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

  void _showModalSignature() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: ModalBottomSheetShape,
        builder: (context) {
          return SignatureFormWidget();
        }).then((signature) {
      setState(() {
        _parafModel = signature;
      });
    });
  }

  void _showModalPembelian() {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      getHeader(context: context, text: 'Tambah Bahan'),
                      getInputWrapper(
                        label: 'Tanggal Datang / Dibeli',
                        input: TextFormField(
                          controller: _tanggalController,
                          decoration: getInputDecoration(
                              label: 'Tanggal Datang / Dibeli'),
                          style: inputTextStyle,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _tanggalController.text.isNotEmpty
                                  ? defaultDateFormat
                                      .parse(_tanggalController.text)
                                  : DateTime.now(),
                              firstDate: DateTime(2016),
                              lastDate: DateTime(2100),
                            );

                            if (picked != null) {
                              setState(() => _tanggalModel = picked);
                              _tanggalController.text =
                                  defaultDateFormat.format(picked);
                            }
                          },
                        ),
                      ),
                      StatefulBuilder(builder: (context, setBahanState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getInputWrapper(
                                label: 'Nama / Merk Bahan',
                                input: DropdownButtonFormField(
                                  items: _bahanHalalOpts
                                      .map((opt) => DropdownMenuItem(
                                            value: opt,
                                            child: Text(opt.name),
                                          ))
                                      .toList(),
                                  onChanged: (BahanHalalOpts? value) {
                                    setBahanState(() {
                                      _namaMerkBahanModel = value;
                                    });
                                  },
                                  decoration: getInputDecoration(
                                      label: 'Nama / Merk / Kode Bahan'),
                                  isDense: true,
                                )),
                            if (_namaMerkBahanModel?.id == 'other')
                              getInputWrapper(
                                  label: 'Nama Bahan Lainnya',
                                  input: TextField(
                                    controller: _namaBahanLainnya,
                                    decoration: getInputDecoration(
                                        label: 'Nama Bahan Lainnya'),
                                    style: inputTextStyle,
                                  )),
                          ],
                        );
                      }),
                      getInputWrapper(
                          label: 'Nama & Negara Produsen',
                          input: TextField(
                            controller: _namaNegaraProdusen,
                            decoration: getInputDecoration(
                                label: 'Nama & Negara Produsen'),
                            style: inputTextStyle,
                          )),
                      StatefulBuilder(builder: (context, setSwitchState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getInputWrapper(
                              label: 'Ada di Daftar Bahan Halal',
                              input: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Switch(
                                    value: _adaDiDaftarBahanHalalModel,
                                    onChanged: (value) {
                                      setSwitchState(() =>
                                          _adaDiDaftarBahanHalalModel = value);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Text(_adaDiDaftarBahanHalalModel
                                      ? 'Ya'
                                      : 'Tidak')
                                ],
                              ),
                            ),
                            if (_adaDiDaftarBahanHalalModel)
                              getInputWrapper(
                                  label: 'No. Sertifikat',
                                  input: TextField(
                                    controller: _noSertifikatController,
                                    decoration: getInputDecoration(
                                        label: 'No. Sertifikat'),
                                    style: inputTextStyle,
                                  )),
                          ],
                        );
                      }),
                      getInputWrapper(
                          label: 'Jumlah Pembelian',
                          input: TextField(
                            controller: _jumlahPembelianController,
                            decoration:
                                getInputDecoration(label: 'Jumlah Pembelian'),
                            style: inputTextStyle,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          )),
                      getInputWrapper(
                        label: 'Exp. Date Bahan',
                        input: TextFormField(
                          controller: _expDateBahanController,
                          decoration:
                              getInputDecoration(label: 'Exp. Date Bahan'),
                          style: inputTextStyle,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  _expDateBahanController.text.isNotEmpty
                                      ? defaultDateFormat
                                          .parse(_expDateBahanController.text)
                                      : DateTime.now(),
                              firstDate: DateTime(2016),
                              lastDate: DateTime(2100),
                            );

                            if (picked != null) {
                              setState(() => _expDateBahanModel = picked);
                              _expDateBahanController.text =
                                  defaultDateFormat.format(picked);
                            }
                          },
                        ),
                      ),
                      StatefulBuilder(builder: (context, setStrukState) {
                        return getInputWrapper(
                            label: 'Struk Pembelian',
                            input: getInputFile(
                              context: context,
                              model: _strukPembelianModel,
                              onChanged: ((file) {
                                setStrukState(
                                    () => _strukPembelianModel = file);
                              }),
                            ));
                      }),
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
                          // input: getInputSignature(
                          //   controller: _parafController,
                          //   context: context
                          // ),
                          input: _parafModel == null
                              ? InkWell(
                                  onTap: () => _showModalSignature(),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(Icons.warning_rounded,
                                          color: Colors.grey[600]),
                                      SizedBox(width: 10),
                                      Text('Input Signature',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600]))
                                    ],
                                  ),
                                )
                              : Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        color: Colors.green),
                                    SizedBox(width: 10),
                                    Text('Inputted',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green))
                                  ],
                                )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Colors.black),
                                SizedBox(width: 10),
                                Text('Tambah',
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[200],
                            ),
                            onPressed: () {
                              if (_tanggalModel == null ||
                                  // _namaMerkBahanController.text.isEmpty ||
                                  _namaMerkBahanModel == null ||
                                  _namaNegaraProdusen.text.isEmpty ||
                                  _expDateBahanModel == null ||
                                  // _parafController.isEmpty
                                  _parafModel == null) {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'Harap isi semua field yang dibutuhkan'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              }

                              _addBahan();
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  void _addBahan() async {
    // final parafBytes = await _parafController.toPngBytes();

    final bahan = UmkmPembelianPemeriksaanBahan(
      tanggal: _tanggalModel!,
      expDateBahan: _expDateBahanModel!,
      // namaMerkBahan: _namaMerkBahanController.text,
      namaMerkBahan: _namaMerkBahanModel!.name,
      namaNegaraProdusen: _namaNegaraProdusen.text,
      adaDiDaftarBahanHalal: _adaDiDaftarBahanHalalModel,
      noSertifikat: _noSertifikatController.text,
      strukPembelian: _strukPembelianModel!,
      jumlahPembalian: int.parse(_jumlahPembelianController.text),
      // paraf: await uint8ListToFile(parafBytes!),
      paraf: _parafModel!,
    );

    setState(() => _listBahan.add(bahan));
    _tanggalModel = null;
    _tanggalController.text = '';
    _expDateBahanModel = null;
    _expDateBahanController.text = '';
    // _namaMerkBahanController.text = '';
    _namaMerkBahanModel = null;
    _namaNegaraProdusen.text = '';
    _adaDiDaftarBahanHalalModel = false;
    _noSertifikatController.text = '';
    _strukPembelianModel = null;
    // _parafController.clear();
    _parafModel = null;
  }

  void _removeBahan(UmkmPembelianPemeriksaanBahan bahan) {
    setState(() => _listBahan.remove(bahan));
  }

  void _submit() async {
    if (_listBahan.isEmpty) {
      final snackBar =
          SnackBar(content: Text('Harap isi daftar bahan terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final core = CoreService();
    final logger = Logger();

    try {
      for (var i = 0; i < _listBahan.length; i++) {
        final bahan = _listBahan[i];
        final strukPembelianFormData = FormData.fromMap({
          'image': await MultipartFile.fromFile(bahan.strukPembelian.path,
              filename: bahan.strukPembelian.path.split('/').last),
        });
        final uploadStruk = await core.genericPost(
            ApiList.imageUpload, null, strukPembelianFormData);
        bahan.setStrukUrl(uploadStruk.data);
      }

      final document = await getUmkmDocument();
      final params = {
        'id': document!.id,
        'data': _listBahan
            .map((bahan) => {
                  'Tanggal': bahan.tanggal.millisecondsSinceEpoch,
                  'nama_dan_merk': bahan.namaMerkBahan,
                  'nama_dan_negara': bahan.namaNegaraProdusen,
                  'halal': bahan.adaDiDaftarBahanHalal,
                  'exp_bahan': bahan.expDateBahan.millisecondsSinceEpoch,
                  'no_sertifikat': bahan.noSertifikat,
                  'struk_pembelian': bahan.strukUploadedUrl,
                  'paraf': bahan.paraf.sign,
                  'jumlah_pembelian': bahan.jumlahPembalian,
                })
            .toList()
      };

      String url;
      if (widget.typeBahan == 'non-import')
        url = ApiList.umkmCreateFormPembelianPemeriksaan;
      else
        url = ApiList.umkmCreateFormPembelianPemeriksaanImport;
      final response = await core.genericPost(url, null, params);
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Sukses menyimpan data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (err, stacktrace) {
      logger.e(stacktrace);
      String message = 'Terjadi kesalahan';
      if (err is DioError) message = err.response?.data['detail'] ?? message;
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _getBahanCard(UmkmPembelianPemeriksaanBahan bahan) {
    final labelTextStyle = TextStyle(color: Colors.grey[400]);

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
                Text(bahan.namaMerkBahan,
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
            style: ElevatedButton.styleFrom(primary: Colors.red),
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
            : 'Pembelian dan Pemeriksaan Bahan Import'),
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
                    Text(
                        widget.typeBahan != 'import'
                            ? 'List Bahan'
                            : 'List Bahan Import',
                        style: _titleTextStyle),
                    TextButton(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline),
                          SizedBox(width: 10),
                          Text('Tambah')
                        ],
                      ),
                      onPressed: _showModalPembelian,
                    )
                  ],
                ),
                SizedBox(height: 10),
                if (_listBahan.isNotEmpty)
                  ..._listBahan.map((bahan) => _getBahanCard(bahan)).toList()
                else
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: getPlaceholder(text: 'Belum ada list bahan'),
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

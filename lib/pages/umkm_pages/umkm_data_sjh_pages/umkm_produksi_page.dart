import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/date_helper.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/modal_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/helpers/utils_helper.dart';
import 'package:halal_chain/models/signature_model.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/signature_form_widget.dart';
import 'package:logger/logger.dart';
import 'package:signature/signature.dart';
import 'package:halal_chain/models/bahan_halal_opt_model.dart';

class UmkmProduksiPage extends StatefulWidget {
  const UmkmProduksiPage({ Key? key }) : super(key: key);

  @override
  State<UmkmProduksiPage> createState() => _UmkmProduksiPageState();
}

class _UmkmProduksiPageState extends State<UmkmProduksiPage> {
  final _titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16
  );

  final List<UmkmProduksi> _listProduksi = [];
  
  DateTime? _tanggalProduksiModel;
  final _tanggalProduksiController = TextEditingController();
  final _namaProdukController = TextEditingController();
  final _jumlahAwalController = TextEditingController();
  final _jumlahProdukKeluarController = TextEditingController();
  final _sisaStokController = TextEditingController();
  UserSignature? _parafModel;
  // final _parafController = SignatureController(
  //   penStrokeWidth: 5
  // );
  // List<BahanHalalOpts> _bahanHalalOpts = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _getBahanOpts();
  // }

  // Future<void> _getBahanOpts() async {
  //   try {
  //     final logger = Logger();
  //     final core = CoreService();
  //     final res = await core.genericGet(ApiList.utilListBahanHalal);
  //     setState(() {
  //       _bahanHalalOpts = res.data
  //           .map<BahanHalalOpts>((d) => BahanHalalOpts.fromJSON(d))
  //           .toList();
  //       logger.i(_bahanHalalOpts.map(
  //           (o) => {'id': o.id, 'name': o.name, 'requireCert': o.requireCert}));
  //     });
  //   } catch (err, trace) {
  //     String message = 'Terjadi kesalahan';
  //     if (err is DioError) message = err.response?.data['detail'];

  //     showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //               title: Text('Error'),
  //               content: Text(message),
  //             ));

  //     rethrow;
  //   }
  // }

  void _showModalSignature() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: ModalBottomSheetShape,
      builder: (context) {
        return SignatureFormWidget();
      }
    ).then((signature) {
      setState(() {
        _parafModel = signature;
      });
    });
  }

  Widget _getProduksiCard(UmkmProduksi produksi) {
    final labelTextStyle = TextStyle(
      color: Colors.grey[400]
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(10),
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
                Text(produksi.namaProduk, style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
                SizedBox(height: 10),
                Wrap(
                  children: [
                    Text('Tanggal Produksi', style: labelTextStyle),
                    SizedBox(width: 10),
                    Text(defaultDateFormat.format(produksi.tanggalProduksi))
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Jumlah Awal', style: labelTextStyle),
                    SizedBox(width: 10),
                    Text('${produksi.jumlahAwal}')
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Produk Keluar', style: labelTextStyle),
                    SizedBox(width: 10),
                    Text('${produksi.jumlahProdukKeluar}')
                  ],
                ),
                SizedBox(height: 5),
                Wrap(
                  children: [
                    Text('Sisa Stok', style: labelTextStyle),
                    SizedBox(width: 10),
                    Text('${produksi.sisaStok}')
                  ],
                ),
                // SizedBox(height: 5),
                // Wrap(
                //   crossAxisAlignment: WrapCrossAlignment.center,
                //   children: [
                //     Text('Paraf', style: labelTextStyle),
                //     SizedBox(width: 10),
                //     if (produksi.paraf) Icon(Icons.check, color: Colors.green)
                //     else Icon(Icons.close, color: Colors.red)
                //   ],
                // ),
                SizedBox(height: 5),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _removeProduksi(produksi),
            child: Text('Remove'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red
            ),
          )
        ],
      ),
    );
  }

  void _addProduksi() async {
    if (
      _namaProdukController.text.isEmpty ||
      _tanggalProduksiModel == null ||
      _jumlahAwalController.text.isEmpty ||
      _jumlahProdukKeluarController.text.isEmpty ||
      _sisaStokController.text.isEmpty ||
      _parafModel == null
      // _parafController.isEmpty
    ) {
      final snackBar = SnackBar(content: Text('Harap isi semua field yang dibutuhkan'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // final parafBytes = await _parafController.toPngBytes();

    final produksi = UmkmProduksi(
      tanggalProduksi: _tanggalProduksiModel!,
      namaProduk: _namaProdukController.text,
      jumlahAwal: int.parse(_jumlahAwalController.text),
      jumlahProdukKeluar: int.parse(_jumlahProdukKeluarController.text),
      sisaStok: int.parse(_sisaStokController.text),
      paraf: _parafModel!,
      // paraf: await uint8ListToFile(parafBytes!),
    );

    setState(() {
      _listProduksi.add(produksi);
      _namaProdukController.text = '';
      _tanggalProduksiController.text = '';
      _jumlahAwalController.text = '';
      _jumlahProdukKeluarController.text = '';
      _sisaStokController.text = '';
      _parafModel = null;
      // _parafController.clear();
    });
  }

  void _removeProduksi(UmkmProduksi produksi) {
    setState(() => _listProduksi.remove(produksi));
  }

  void _submit() async {
    if (_listProduksi.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap isi daftar produksi terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final core = CoreService();
      final document = await getUmkmDocument();

      // upload each produksi signature image
      // for (int i = 0; i < _listProduksi.length; i++) {
      //   final produksi = _listProduksi[i];
      //   final formData = FormData.fromMap({
      //     'image': await MultipartFile.fromFile(
      //       produksi.paraf.path,
      //       filename: produksi.paraf.path.split('/').last
      //     )
      //   });
      //   final upload = await core.genericPost(ApiList.imageUpload, null, formData);
      //   produksi.setParafUrl(upload.data);
      // }

      final params = {
        'id': document!.id,
        'data': _listProduksi.map((produksi) => {
          'tanggal_produksi': produksi.tanggalProduksi.millisecondsSinceEpoch,
          'nama_produk': produksi.namaProduk,
          'jumlah_awal': produksi.jumlahAwal,
          'jumlah_produk_keluar': produksi.jumlahProdukKeluar,
          'sisa_stok': produksi.sisaStok,
          'paraf': produksi.paraf.sign
        }).toList()
      };
      
      final response = await core.genericPost(ApiList.umkmCreateFormProduksi, null, params);
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
        title: Text('Produksi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daftar Produksi', style: _titleTextStyle),
                SizedBox(height: 10),
                if (_listProduksi.isEmpty) Text('Belum ada produksi')
                else ..._listProduksi.map((produksi) => _getProduksiCard(produksi)).toList(),
                SizedBox(height: 30),

                Text('Tambah Produksi', style: _titleTextStyle),
                SizedBox(height: 10),
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
                    onChanged: (picked) {
                      setState(() => _tanggalProduksiModel = picked);
                    },
                    context: context
                  )
                ),
                getInputWrapper(
                  label: 'Jumlah Awal',
                  input: TextField(
                    controller: _jumlahAwalController,
                    decoration: getInputDecoration(label: 'Jumlah Awal'),
                    style: inputTextStyle,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  )
                ),
                getInputWrapper(
                  label: 'Jumlah Produk Keluar',
                  input: TextField(
                    controller: _jumlahProdukKeluarController,
                    decoration: getInputDecoration(label: 'Jumlah Produk Keluar'),
                    style: inputTextStyle,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  )
                ),
                getInputWrapper(
                  label: 'Sisa Stok',
                  input: TextField(
                    controller: _sisaStokController,
                    decoration: getInputDecoration(label: 'Sisa Stok'),
                    style: inputTextStyle,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  )
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
                  //     SizedBox(width: 5,),
                  //     Text(_parafModel ? 'Ya' : 'Tidak')
                  //   ],
                  // ),
                  // input: getInputSignature(
                  //   controller: _parafController,
                  //   context: context
                  // )
                  input: _parafModel == null ? InkWell(
                    onTap: () => _showModalSignature(),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.warning_rounded, color: Colors.grey[600]),
                        SizedBox(width: 10),
                        Text('Input Signature', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]
                        ))
                      ],
                    ),
                  )
                  : Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green),
                      SizedBox(width: 10),
                      Text('Inputted', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ))
                    ],
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addProduksi(),
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
                    )
                  ],
                ),
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
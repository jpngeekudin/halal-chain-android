import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/form_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:logger/logger.dart';

class UmkmMatriksProdukPage extends StatefulWidget {
  const UmkmMatriksProdukPage({ Key? key }) : super(key: key);

  @override
  State<UmkmMatriksProdukPage> createState() => _UmkmMatriksProdukPageState();
}

class _UmkmMatriksProdukPageState extends State<UmkmMatriksProdukPage> {

  final _titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16
  );

  final _produkController = TextEditingController();
  final _namaBahanController = TextEditingController();
  Map<String, bool> _matriksProdukModel = {};

  final List<String> _listProduk = [];
  final List<UmkmMatriks> _listMatriks = [];

  Widget _getMatriksTable(List<UmkmMatriks> matriks) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(
          color: Theme.of(context).dividerColor
        ),
        defaultColumnWidth: IntrinsicColumnWidth(),
        children: [
          TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Nama Bahan', style: TextStyle(
                    fontWeight: FontWeight.bold
                  )),
                )
              ),
              ..._listProduk.map((produk) => TableCell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(produk, style: TextStyle(
                    fontWeight: FontWeight.bold
                  )),
                ),
              ))
            ]
          ),
          ...matriks.map((matrik) => TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(matrik.namaBahan),
                )
              ),
              ..._listProduk.map((produk) => TableCell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: matrik.produk[produk] ?? false
                    ? Icon(Icons.check, color: Colors.green)
                    : Icon(Icons.close, color: Colors.red),
                ),
              ))
            ]
          ))
        ],
      ),
    );
  }

  void _addProduk() {
    if (_produkController.text.isEmpty) return;
    final produk = _produkController.text;
    if (_listProduk.contains(produk)) {
      const snackBar = SnackBar(content: Text('Produk sudah ada'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() => _listProduk.add(produk));
    _produkController.text = '';
    
    Map<String, bool> matriksProduk = {};
    _listProduk.forEach((produk) => matriksProduk[produk] = false);
    _matriksProdukModel = matriksProduk;
  }

  void _removeProduk(String produk) {
    setState(() => _listProduk.remove(produk));
  }

  void _addMatriks() {
    String error = '';
    if (_namaBahanController.text.isEmpty) error = 'Harap masukkan nama bahan';
    else if (_listProduk.isEmpty) error = 'Harap isi produk terlebih dahulu';

    if (error.isNotEmpty) {
      final snackBar = SnackBar(content: Text(error));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final matriks = UmkmMatriks(namaBahan: _namaBahanController.text, produk: _matriksProdukModel);
    setState(() {
      _listMatriks.add(matriks);
      _namaBahanController.text = '';
      
      Map<String, bool> matriksProduk = {};
      _listProduk.forEach((produk) => matriksProduk[produk] = false);
      _matriksProdukModel = matriksProduk;
    });
  }

  void _removeMatriks(UmkmMatriks matriks) {
    setState(() => _listMatriks.remove(matriks));
  }

  void _submit() async {
    if (_listMatriks.isEmpty) {
      final snackBar = SnackBar(content: Text('Harap isi matriks terlebih dahulu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final document = await getUmkmDocument();
    final params = {
      'id': document!.id,
      'data': _listMatriks.map((matriks) {
        // Map<String, dynamic> item = { 'nama_bahan': matriks.namaBahan };
        // matriks.produk.entries.forEach((element) => item[element.key] = element.value);
        // return item;
        return {
          'nama_bahan': matriks.namaBahan,
          'list_barang': matriks.produk.entries.map((e) => {
            'barang': e.key,
            'status': e.value
          }).toList()
        };
      }).toList()
    };
    
    try {
      final core = CoreService();
      final response = await core.genericPost(ApiList.umkmMatriksProduk, null, params);
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
        title: Text('Matriks Produk'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daftar Produk', style: _titleTextStyle),
                SizedBox(height: 10),
                if (_listProduk.isEmpty) Text('Belum ada daftar produk')
                else ..._listProduk.map((produk) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(produk),
                        InkWell(
                          child: Icon(Icons.remove, color: Colors.red),
                          onTap: () => _removeProduk(produk),
                        )
                      ],
                    ),
                  );
                }),
                SizedBox(height: 30),

                Text('Tambah Produk', style: _titleTextStyle),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _produkController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10
                          ),
                          hintText: 'Nama Produk'
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _addProduk(),
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
                SizedBox(height: 30),

                Text('Daftar Matriks Produk', style: _titleTextStyle),
                SizedBox(height: 10),
                if (_listMatriks.isEmpty) Text('Belum ada daftar matriks produk')
                else _getMatriksTable(_listMatriks),
                // else Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Container(
                //           padding: EdgeInsets.all(10),
                //           child: Text('Bahan'),
                //         ),
                //         ..._listMatriks.map((matriks) {
                //           return Container(
                //             padding: EdgeInsets.all(10),
                //             child: Text(matriks.namaBahan),
                //           );
                //         })
                //       ],
                //     ),
                //     Flexible(
                //       child: SingleChildScrollView(
                //         scrollDirection: Axis.horizontal,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Row(
                //               children: [
                //                 ..._listProduk.map((produk) {
                //                   return Container(
                //                     padding: EdgeInsets.all(10),
                //                     child: Text(produk),
                //                   );
                //                 })
                //               ],
                //             ),
                //             ..._listMatriks.map((matriks) {
                //               return Row(
                //                 children: [
                //                   ..._listProduk.map((produk) {
                //                     final value = matriks.produk[produk] ?? false;
                //                     return Container(
                //                       child: value
                //                         ? Icon(Icons.check, color: Colors.green)
                //                         : Icon(Icons.close, color: Colors.red),
                //                     );
                //                   })
                //                 ],
                //               );
                //             })
                //           ],
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                SizedBox(height: 30),

                Text('Tambah Matriks', style: _titleTextStyle),
                SizedBox(height: 10),
                getInputWrapper(
                  label: 'Nama Bahan',
                  input: TextField(
                    controller: _namaBahanController,
                    decoration: getInputDecoration(label: 'Nama Bahan'),
                    style: inputTextStyle,
                  )
                ),
                ..._listProduk.map((produk) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(produk),
                      Switch(
                        value: _matriksProdukModel[produk] ?? false,
                        onChanged: (value) {
                          setState(() => _matriksProdukModel[produk] = value);
                        },
                      )
                    ],
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addMatriks(),
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
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/helpers/auth_helper.dart';
import 'package:halal_chain/helpers/umkm_helper.dart';
import 'package:halal_chain/models/umkm_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:halal_chain/services/core_service.dart';
import 'package:halal_chain/widgets/home_item_widget.dart';

class UmkmDataSjhPage extends StatefulWidget {
  const UmkmDataSjhPage({ Key? key }) : super(key: key);

  @override
  State<UmkmDataSjhPage> createState() => _UmkmDataSjhPageState();
}

class _UmkmDataSjhPageState extends State<UmkmDataSjhPage> {

  Future _createInit() async {
    final core = CoreService();
    final userData = await getUserData();
    final response = await core.createInit(userData!.id);
    return response.data;
  }

  Future<UmkmDocument?> _getUmkmDocument() async {
    try {
      // final currentDocument = await getUmkmDocument();
      // if (currentDocument != null) return currentDocument;

      final core = CoreService();
      final userData = await getUserData();
      final response = await core.genericGet(ApiList.umkmGetDocument, { 'creator_id': userData!.id });

      if (response.data != null) {
        final umkmDocument = UmkmDocument.fromJSON(response.data);
        setUmkmDocument(umkmDocument);
        return umkmDocument;
      }

      else {
        final createInitResponse = await _createInit();
        return await _getUmkmDocument();
      }
    }

    catch(err, stacktrace) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data SJH'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
            future: _getUmkmDocument(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final UmkmDocument document = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Create Init',
                        subtitle: 'Initializing a docs',
                        isDone: true,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Detail UMKM',
                        subtitle: 'Inserting UMKM Details',
                        route: '/umkm/data-sjh/detail-umkm',
                        isDone: document.detailUmkm,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Penetapan Tim',
                        subtitle: 'Menetapkan orang-orang yang bekerja di tim',
                        route: '/umkm/data-sjh/penetapan-tim',
                        isDone: document.penetapanTim,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Bukti Pelaksanaan',
                        subtitle: 'Memasukkan bukti pelaksanaan',
                        route: '/umkm/data-sjh/bukti-pelaksanaan',
                        isDone: document.buktiPelaksanaan,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Evaluasi',
                        subtitle: 'Quiz Test Evaluasi',
                        route: '/umkm/data-sjh/evaluasi',
                        isDone: document.jawabanEvaluasi,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Audit Internal',
                        subtitle: 'Audit Internal',
                        route: '/umkm/data-sjh/audit-internal',
                        isDone: document.jawabanAudit
                      ),
                    ), 
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Daftar Hadir Kajian',
                        subtitle: 'Mengisi daftar hadir kajian',
                        route: '/umkm/data-sjh/daftar-hadir-kajian',
                        isDone: document.daftarHasilKaji,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Pembelian dan Pemeriksaan Bahan',
                        subtitle: 'Mengisi daftar pembelian dan pemeriksaan bahan',
                        route: '/umkm/data-sjh/pembelian-bahan',
                        isDone: document.pembelian,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Pembelian dan Pemeriksaan Bahan Import',
                        subtitle: 'Mengisi daftar pembelian dan pemeriksaan bahan import',
                        route: '/umkm/data-sjh/pembelian-bahan-import',
                        isDone: document.pembelianImport
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Stok Bahan',
                        subtitle: 'Mengisi form stok bahan',
                        route: '/umkm/data-sjh/stok-bahan',
                        isDone: document.stokBarang,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Produksi',
                        subtitle: 'Mengisi form produksi',
                        route: '/umkm/data-sjh/produksi',
                        isDone: document.formProduksi,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Pemusnahan Barang / Produk',
                        subtitle: 'Mengisi form pemusnahan barang / produk',
                        route: '/umkm/data-sjh/pemusnahan',
                        isDone: document.formPemusnahan,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Pengecekan Kebersihan',
                        subtitle: 'Mengisi form pengecekan kebersihan fasilitas produksi dan kendaraan',
                        route: '/umkm/data-sjh/kebersihan',
                        isDone: document.formPengecekanKebersihan,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Bahan Halal',
                        subtitle: 'Mengisi form daftar bahan halal',
                        route: '/umkm/data-sjh/bahan-halal',
                        isDone: document.daftarBahanHalal,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: HomeItemWidget(
                        title: 'Matriks Produk',
                        subtitle: 'Mengisi form matriks produk',
                        route: '/umkm/data-sjh/matriks',
                        isDone: document.matriksProduk,
                      ),
                    ),
                  ],
                );
              }

              else {
                return Container(
                  height: 400,
                  alignment: Alignment.center,
                  child: snapshot.hasError
                    ? Text('Terjadi kesalahan', style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ))
                    : CircularProgressIndicator(),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}
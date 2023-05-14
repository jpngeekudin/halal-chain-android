import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:halal_chain/models/signature_model.dart';
import 'package:logger/logger.dart';

class UmkmDocument {
  late String id;
  late String status;
  late bool detailUmkm;
  late bool penetapanTim;
  late bool buktiPelaksanaan;
  late bool jawabanEvaluasi;
  late bool jawabanAudit;
  late bool daftarHasilKaji;
  late bool pembelian;
  late bool pembelianImport;
  late bool stokBarang;
  late bool formProduksi;
  late bool formPemusnahan;
  late bool formPengecekanKebersihan;
  late bool daftarBahanHalal;
  late bool matriksProduk;

  UmkmDocument({
    required this.id,
    required this.status,
    required this.detailUmkm,
    required this.penetapanTim,
    required this.buktiPelaksanaan,
    required this.jawabanEvaluasi,
    required this.jawabanAudit,
    required this.daftarHasilKaji,
    required this.pembelian,
    required this.pembelianImport,
    required this.stokBarang,
    required this.formProduksi,
    required this.formPemusnahan,
    required this.formPengecekanKebersihan,
    required this.daftarBahanHalal,
    required this.matriksProduk
  });

  UmkmDocument.fromJSON(Map<String, dynamic> json) {
    id = json['_id'];
    status = json['status'];
    detailUmkm = json['detail_umkm'];
    penetapanTim = json['penetapan_tim'];
    buktiPelaksanaan = json['bukti_pelaksanaan'];
    jawabanEvaluasi = json['jawaban_evaluasi'];
    jawabanAudit = json['jawaban_audit'];
    daftarHasilKaji = json['daftar_hasil_kaji'];
    pembelian = json['pembelian'];
    pembelianImport = json['pembelian_import'];
    stokBarang = json['stok_barang'];
    formProduksi = json['form_produksi'];
    formPemusnahan = json['form_pemusnahan'];
    formPengecekanKebersihan = json['form_pengecekan_kebersihan'];
    daftarBahanHalal = json['daftar_bahan_halal'];
    matriksProduk = json['matriks_produk'];
  }

  Map<String, dynamic> toJSON() {
    return {
      '_id': id,
      'status': status,
      'detail_umkm': detailUmkm,
      'penetapan_tim': penetapanTim,
      'bukti_pelaksanaan': buktiPelaksanaan,
      'jawaban_evaluasi': jawabanEvaluasi,
      'jawaban_audit': jawabanAudit,
      'daftar_hasil_kaji': daftarHasilKaji,
      'pembelian': pembelian,
      'pembelian_import': pembelianImport,
      'stok_barang': stokBarang,
      'form_produksi': formProduksi,
      'form_pemusnahan': formPemusnahan,
      'form_pengecekan_kebersihan': formPengecekanKebersihan,
      'daftar_bahan_halal': daftarBahanHalal,
      'matriks_produk': matriksProduk
    };
  }

  bool allFilled() {
    return detailUmkm
      && penetapanTim
      && buktiPelaksanaan
      && jawabanEvaluasi
      && jawabanAudit
      && daftarHasilKaji
      && pembelian
      && pembelianImport
      && stokBarang
      && formProduksi
      && formPemusnahan
      && formPengecekanKebersihan
      && daftarBahanHalal
      && matriksProduk;
  }
}

class UmkmTeamAssignment {
  String nama;
  String jabatan;
  String position;

  UmkmTeamAssignment(this.nama, this.jabatan, this.position);

  Map<String, String> toJSON() => {
    'nama': nama,
    'jabatan': jabatan,
    'position': position
  };
}

class UmkmTeamAssignmentWithScore {
  String nama;
  // String jabatan;
  String position;
  String ttd;
  int nilai;

  UmkmTeamAssignmentWithScore({
    required this.nama,
    // required this.jabatan,
    this.position = '',
    this.ttd = '',
    required String nilai
  }) : nilai = int.parse(nilai);

  Map<String, dynamic> toJSON() => {
    'nama': nama,
    // 'jabatan': jabatan,
    'posisi': position,
    'ttd': '',
    'nilai': nilai
  };
}

class UmkmSoalEvaluasi {
  late int id;
  late String soal;
  late List<UmkmJawabSoalEvaluasi> jawabanList;
  String? jawaban;

  UmkmSoalEvaluasi({ required this.id, required this.soal, required this.jawabanList });

  UmkmSoalEvaluasi.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    soal = json['soal'];
    jawabanList = json['jawaban'].entries.map<UmkmJawabSoalEvaluasi>((entry) => UmkmJawabSoalEvaluasi(entry.key, entry.value)).toList();
  }

  void setJawaban(String jawab) {
    jawaban = jawab;
  }
}

class UmkmJawabSoalEvaluasi {
  String key;
  String value;

  UmkmJawabSoalEvaluasi(this.key, this.value);
}

class UmkmSoalAudit {
  int id;
  String soal;
  bool? jawaban;
  TextEditingController? keterangan;

  UmkmSoalAudit(this.id, this.soal);

  void setJawaban(bool jawaban) {
    jawaban = jawaban;
  }
}

class UmkmDaftarHadirKaji {
  String nama;
  String jabatan;
  String? paraf;

  UmkmDaftarHadirKaji(this.nama, this.jabatan, this.paraf);
}

class UmkmDaftarHadirKajiPembahasan {
  String pembahasan;
  String perbaikan;

  UmkmDaftarHadirKajiPembahasan(this.pembahasan, this.perbaikan);
}

class UmkmPembelianPemeriksaanBahan {
  DateTime tanggal;
  String namaMerkBahan;
  String namaNegaraProdusen;
  bool adaDiDaftarBahanHalal;
  DateTime expDateBahan;
  String noSertifikat;
  File strukPembelian;
  int jumlahPembalian;
  String? strukUploadedUrl;
  UserSignature paraf;
  String? parafUploadedUrl;

  UmkmPembelianPemeriksaanBahan({
    required this.tanggal,
    required this.namaMerkBahan,
    required this.namaNegaraProdusen,
    required this.adaDiDaftarBahanHalal,
    required this.expDateBahan,
    required this.noSertifikat,
    required this.strukPembelian,
    required this.paraf,
    required this.jumlahPembalian
  });

  void setParafUrl(String url) {
    parafUploadedUrl = url;
  }

  void setStrukUrl(String url) {
    strukUploadedUrl = url;
  }
}

class UmkmStokBarang {
  DateTime tanggalBeli;
  String namaBahan;
  String jumlahBahan;
  String jumlahKeluar;
  String stokSisa;
  UserSignature paraf;
  // File paraf;
  // String? uploadedParafUrl;

  UmkmStokBarang({
    required this.tanggalBeli,
    required this.namaBahan,
    required this.jumlahBahan,
    required this.jumlahKeluar,
    required this.stokSisa,
    required this.paraf
  });

  // void setParafUrl(String url) {
  //   uploadedParafUrl = url;
  // }
}

class UmkmProduksi {
  DateTime tanggalProduksi;
  String namaProduk;
  int jumlahAwal;
  int jumlahProdukKeluar;
  int sisaStok;
  // File paraf;
  // String? uploadedParafUrl;
  UserSignature paraf;

  UmkmProduksi({
    required this.tanggalProduksi,
    required this.namaProduk,
    required this.jumlahAwal,
    required this.jumlahProdukKeluar,
    required this.sisaStok,
    required this.paraf
  });

  // void setParafUrl(String url) {
  //   uploadedParafUrl = url;
  // }
}

class UmkmPemusnahan {
  DateTime tanggalProduksi;
  String namaProduk;
  String jumlah;
  String penyebab;
  DateTime tanggalPemusnahan;
  String penanggungjawab;

  UmkmPemusnahan({
    required this.tanggalPemusnahan,
    required this.tanggalProduksi,
    required this.namaProduk,
    required this.jumlah,
    required this.penyebab,
    required this.penanggungjawab
  });
}

class UmkmKebersihan {
  DateTime tanggal;
  bool produksi;
  bool gudang;
  bool mesin;
  bool kendaraan;
  String penanggungjawab;

  UmkmKebersihan({
    required this.tanggal,
    required this.produksi,
    required this.gudang,
    required this.mesin,
    required this.kendaraan,
    required this.penanggungjawab
  });
}

class UmkmBahanHalal {
  String namaMerk;
  String namaNegara;
  String pemasok;
  String penerbit;
  String nomor;
  DateTime? masaBerlaku;
  String dokumenLain;
  String keterangan;

  UmkmBahanHalal({
    required this.namaMerk,
    required this.namaNegara,
    required this.pemasok,
    required this.penerbit,
    required this.nomor,
    this.masaBerlaku,
    required this.dokumenLain,
    required this.keterangan
  });
}

class UmkmMatriks {
  String namaBahan;
  Map<String, bool> produk;

  UmkmMatriks({
    required this.namaBahan,
    required this.produk
  });
}

class UmkmSimulasiBahan {
  String bahan;
  bool halal;
  int? nomorSertifikat;
  DateTime inputDate;
  DateTime updateDate ;

  UmkmSimulasiBahan({
    required this.bahan,
    required this.halal,
    this.nomorSertifikat,
    inputDate,
    updateDate
  }) : inputDate = inputDate ?? DateTime.now(),
    updateDate = updateDate ?? DateTime.now();

  Map<String, dynamic> toJSON() {
    return {
      'bahan': bahan,
      'halal': halal,
      'nomor_sertifikat': nomorSertifikat ?? 0,
      'input_date': inputDate.millisecondsSinceEpoch,
      'update_date': inputDate.millisecondsSinceEpoch
    };
  }
}

class UmkmAuditInternal {
  late String id;
  late String docId;
  late UmkmAuditInternalData data;
  
  UmkmAuditInternal({
    required this.id,
    required this.docId,
    required this.data
  });

  UmkmAuditInternal.fromJSON(Map<String, dynamic> json) {
    id = json['_id'];
    docId = json['doc_id'];
    data = UmkmAuditInternalData(
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['data']['created_at']),
      auditee: json['data']['auditee'],
      namaAuditor: json['data']['nama_auditor'],
      bagianDiaudit: json['data']['bagian_diaudit'],
      data: json['data']['data'].map<UmkmAuditInternalAnswer>((answer) {
        return UmkmAuditInternalAnswer(
          id: answer['id'],
          jawaban: answer['jawaban'],
          keterangan: answer['keterangan']
        );
      }).toList(),
    );
  }
}

class UmkmAuditInternalData {
  DateTime createdAt;
  String auditee;
  String namaAuditor;
  String bagianDiaudit;
  List<UmkmAuditInternalAnswer> data;

  UmkmAuditInternalData({
    required this.createdAt,
    required this.auditee,
    required this.namaAuditor,
    required this.bagianDiaudit,
    required this.data
  });
}

class UmkmAuditInternalAnswer {
  String id;
  bool jawaban;
  String keterangan;

  UmkmAuditInternalAnswer({
    required this.id,
    required this.jawaban,
    required this.keterangan
  });
}
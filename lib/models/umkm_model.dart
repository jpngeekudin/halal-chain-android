import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

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
  String jabatan;
  String position;
  int nilai;

  UmkmTeamAssignmentWithScore(
    this.nama,
    this.jabatan,
    this.position,
    String nilai
  ) : nilai = int.parse(nilai);

  Map<String, dynamic> toJSON() => {
    'nama': nama,
    'jabatan': jabatan,
    'position': position,
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
  bool paraf;

  UmkmPembelianPemeriksaanBahan({
    required this.tanggal,
    required this.namaMerkBahan,
    required this.namaNegaraProdusen,
    required this.adaDiDaftarBahanHalal,
    required this.expDateBahan,
    required this.paraf
  });
}

class UmkmStokBarang {
  DateTime tanggalBeli;
  String namaBahan;
  String jumlahBahan;
  String jumlahKeluar;
  String stokSisa;
  bool paraf;

  UmkmStokBarang({
    required this.tanggalBeli,
    required this.namaBahan,
    required this.jumlahBahan,
    required this.jumlahKeluar,
    required this.stokSisa,
    required this.paraf
  });
}
// UMKM DETAIL

class SjhUmkmDetail {
  late String namaKetua;
  late String noTelpKetua;
  late String noKtpKetua;
  late String namaPenanggungjawab;
  late String logoPerusahaan;
  late String ttdPenanggungjawab;
  late String ttdKetua;

  SjhUmkmDetail({
    required this.namaKetua,
    required this.noTelpKetua,
    required this.noKtpKetua,
    required this.namaPenanggungjawab,
    required this.logoPerusahaan,
    required this.ttdPenanggungjawab,
    required this.ttdKetua
  });

  SjhUmkmDetail.fromJSON(Map<String, dynamic> json) {
    namaKetua = json['nama_ketua'];
    noTelpKetua = json['no_telp_ketua'];
    noKtpKetua = json['no_ktp_ketua'];
    namaPenanggungjawab = json['nama_penanggungjawab'];
    logoPerusahaan = json['logo_perusahaan'];
    ttdPenanggungjawab = json['ttd_penanggungjawab'];
    ttdKetua = json['ttd_ketua'];
  }
}

// PENETAPAN TIM

class SjhPenetapanTimItem {
  late String nama;
  late String jabatan;
  late String position;

  SjhPenetapanTimItem({
    required this.nama,
    required this.jabatan,
    required this.position
  });

  SjhPenetapanTimItem.fromJSON(Map<String, dynamic> json) {
    nama = json['nama'];
    jabatan = json['jabatan'];
    position = json['position'];
  }
}

// BUKTI PELAKSANAAN

class SjhBuktiPelaksanaan {
  late DateTime tanggalPelaksanaan;
  late String pemateri;
  late List<SjhBuktiPelaksanaanData> data;

  SjhBuktiPelaksanaan({
    required this.tanggalPelaksanaan,
    required this.pemateri,
    required this.data
  });

  SjhBuktiPelaksanaan.fromJSON(Map<String, dynamic> json) {
    tanggalPelaksanaan = DateTime.fromMillisecondsSinceEpoch(json['tanggal_pelaksanaan']);
    pemateri = json['pemateri'];
    data = json['data'].map<SjhBuktiPelaksanaanData>((data) => SjhBuktiPelaksanaanData(
      nama: data['nama'],
      posisi: data['posisi'],
      ttd: data['ttd'],
      nilai: data['nilai'] ?? 0
    )).toList();
  }
}

class SjhBuktiPelaksanaanData {
  String nama;
  String posisi;
  String ttd;
  int nilai;

  SjhBuktiPelaksanaanData({
    required this.nama,
    required this.posisi,
    required this.ttd,
    required this.nilai
  });
}

// EVALUASI

class SjhEvaluasi {
  late String nama;
  late DateTime tanggal;
  late Map<String, dynamic> data;

  SjhEvaluasi({
    required this.nama,
    required this.tanggal,
    required this.data
  });

  SjhEvaluasi.fromJSON(Map<String, dynamic> json) {
    nama = json['nama'];
    tanggal = DateTime.fromMillisecondsSinceEpoch(json['tanggal']);
    data = json['data'];
  }
}

// DAFTAR HADIR KAJI

class SjhDaftarHadirKaji {
  late DateTime tanggal;
  late List<SjhDaftarHadirKajiOrang> orangList;
  late List<SjhDaftarHadirKajiPembahasan> pembahasanList;

  SjhDaftarHadirKaji({
    required this.tanggal,
    required this.orangList,
    required this.pembahasanList
  });

  SjhDaftarHadirKaji.fromJSON(Map<String, dynamic> json) {
    tanggal = DateTime.fromMillisecondsSinceEpoch(int.parse(json['tanggal']));
    orangList = json['list_orang'].map<SjhDaftarHadirKajiOrang>((json) => SjhDaftarHadirKajiOrang.fromJSON(json)).toList();
    pembahasanList = json['pembahasan'].map<SjhDaftarHadirKajiPembahasan>((json) => SjhDaftarHadirKajiPembahasan(
      pembahasan: json['pembahasan'],
      perbaikan: json['perbaikan']
    )).toList();
  }
}

class SjhDaftarHadirKajiOrang {
  late String nama;
  late String jabatan;
  late String paraf;

  SjhDaftarHadirKajiOrang({
    required this.nama,
    required this.jabatan,
    required this.paraf
  });

  SjhDaftarHadirKajiOrang.fromJSON(Map<String, dynamic> json) {
    nama = json['nama'];
    jabatan = json['jabatan'];
    paraf = json['paraf'];
  }
}

class SjhDaftarHadirKajiPembahasan {
  String pembahasan;
  String perbaikan;

  SjhDaftarHadirKajiPembahasan({
    required this.pembahasan,
    required this.perbaikan
  });
}
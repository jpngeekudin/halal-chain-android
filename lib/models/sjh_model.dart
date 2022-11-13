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
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

// PEMBELIAN DAN PEMERIKSAAN BAHAN

class SjhPembelianBahanItem {
  late DateTime tanggal;
  late String namaDanMerk;
  late String namaDanNegara;
  late bool halal;
  late DateTime expBahan;
  late String paraf;

  SjhPembelianBahanItem({
    required this.tanggal,
    required this.namaDanMerk,
    required this.namaDanNegara,
    required this.halal,
    required this.expBahan,
    required this.paraf
  });

  SjhPembelianBahanItem.fromJSON(Map<String, dynamic> json) {
    tanggal = DateTime.fromMillisecondsSinceEpoch(int.parse(json['Tanggal']));
    namaDanMerk = json['nama_dan_merk'];
    namaDanNegara = json['nama_dan_negara'];
    halal = json['halal'].toString().toLowerCase() == 'true';
    expBahan = DateTime.fromMillisecondsSinceEpoch(int.parse(json['exp_bahan']));
    paraf = json['paraf'];
  }
}

// STOK BARANG

class SjhStokBarangItem {
  late DateTime tanggalBeli;
  late String namaBahan;
  late String jumlahBahan;
  late String jumlahKeluar;
  late String stokSisa;
  late String paraf;

  SjhStokBarangItem({
    required this.tanggalBeli,
    required this.namaBahan,
    required this.jumlahBahan,
    required this.jumlahKeluar,
    required this.stokSisa,
    required this.paraf
  });

  SjhStokBarangItem.fromJSON(Map<String, dynamic> json) {
    tanggalBeli = DateTime.fromMillisecondsSinceEpoch(int.parse(json['tanggal_beli']));
    namaBahan = json['nama_bahan'];
    jumlahBahan = json['jumlah_bahan'];
    jumlahKeluar = json['jumlah_keluar'];
    stokSisa = json['stok_sisa'];
    paraf = json['paraf'];
  }
}

// PRODUKSI

class SjhProduksiItem {
  late DateTime tanggalProduksi;
  late String namaProduk;
  late String jumlahAwal;
  late String jumlahProdukKeluar;
  late String sisaStok;
  late String paraf;

  SjhProduksiItem({
    required this.tanggalProduksi,
    required this.namaProduk,
    required this.jumlahAwal,
    required this.jumlahProdukKeluar,
    required this.sisaStok,
    required this.paraf
  });

  SjhProduksiItem.fromJSON(Map<String, dynamic> json) {
    tanggalProduksi = DateTime.fromMillisecondsSinceEpoch(int.parse(json['tanggal_produksi']));
    namaProduk = json['nama_produk'];
    jumlahAwal = json['jumlah_awal'];
    jumlahProdukKeluar = json['jumlah_produk_keluar'];
    sisaStok = json['sisa_stok'];
    paraf = json['paraf'];
  }
}

// PEMUSNAHAN

class SjhPemusnahanItem {
  late DateTime tanggalProduksi;
  late DateTime tanggalPemusnahan;
  late String namaProduk;
  late String jumlah;
  late String penyebab;
  late String penananggungjawab;

  SjhPemusnahanItem({
    required this.tanggalProduksi,
    required this.tanggalPemusnahan,
    required this.namaProduk,
    required this.jumlah,
    required this.penyebab,
    required this.penananggungjawab
  });

  SjhPemusnahanItem.fromJSON(Map<String, dynamic> json) {
    tanggalProduksi = DateTime.fromMillisecondsSinceEpoch(int.parse(json['tanggal_produksi']));
    tanggalPemusnahan = DateTime.fromMillisecondsSinceEpoch(int.parse(json['tanggal_produksi']));
    namaProduk = json['nama_produk'];
    jumlah = json['jumlah'];
    penyebab = json['penyebab'];
    penananggungjawab = json['penanggungjawab'];
  }
}

// KEBERSIHAN

class SjhKebersihanItem {
  late DateTime tanggal;
  late bool produksi;
  late bool gudang;
  late bool mesin;
  late bool kendaraan;
  late String penanggungjawab;

  SjhKebersihanItem({
    required this.tanggal,
    required this.produksi,
    required this.gudang,
    required this.mesin,
    required this.kendaraan,
    required this.penanggungjawab
  });

  SjhKebersihanItem.fromJSON(Map<String, dynamic> json) {
    tanggal = DateTime.fromMillisecondsSinceEpoch(int.parse(json['tanggal']));
    produksi = json['produksi'];
    gudang = json['gudang'];
    mesin = json['mesin'];
    kendaraan = json['kendaraan'];
    penanggungjawab = json['penanggungjawab'];
  }
}

// BAHAN HALAL

class SjhBahanHalalItem {
  late String namaMerk;
  late String namaNegara;
  late String pemasok;
  late String penerbit;
  late String nomor;
  late DateTime masaBerlaku;
  late String dokumenLain;
  late String keterangan;

  SjhBahanHalalItem({
    required this.namaMerk,
    required this.namaNegara,
    required this.pemasok,
    required this.penerbit,
    required this.nomor,
    required this.masaBerlaku,
    required this.dokumenLain,
    required this.keterangan
  });

  SjhBahanHalalItem.fromJSON(Map<String, dynamic> json) {
    namaMerk = json['nama_merk'];
    namaNegara = json['nama_negara'];
    pemasok = json['pemasok'];
    penerbit = json['penerbit'];
    nomor = json['nomor'];
    masaBerlaku = DateTime.fromMillisecondsSinceEpoch(int.parse(json['masa_berlaku']));
    dokumenLain = json['dokumen_lain'];
    keterangan = json['keterangan'];
  }
}

// MATRIKS PRODUK

class SjhMatriksItem {
  late String namaBahan;
  late List<SjhMatriksBahan> listBahan;

  SjhMatriksItem({
    required this.namaBahan,
    required this.listBahan
  });

  SjhMatriksItem.fromJSON(Map<String, dynamic> json) {
    namaBahan = json['nama_bahan'];
    listBahan = json['list_barang'].map<SjhMatriksBahan>((e) => SjhMatriksBahan(e['barang'], e['status'])).toList();
  }
}

class SjhMatriksBahan {
  String barang;
  bool? status;

  SjhMatriksBahan(this.barang, this.status);
}
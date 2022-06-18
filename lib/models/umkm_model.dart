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
import 'package:flutter/cupertino.dart';

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
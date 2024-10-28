// To parse this JSON data, do
//
//     final menu = menuFromJson(jsonString);

import 'dart:convert';

Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
  int id;
  String namaMenu;
  String jenis;
  String deskripsi;
  String gambar;
  int harga;

  Menu({
    required this.id,
    required this.namaMenu,
    required this.jenis,
    required this.deskripsi,
    required this.gambar,
    required this.harga,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        namaMenu: json["nama_menu"],
        jenis: json["jenis"],
        deskripsi: json["deskripsi"],
        gambar: json["gambar"],
        harga: json["harga"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_menu": namaMenu,
        "jenis": jenis,
        "deskripsi": deskripsi,
        "gambar": gambar,
        "harga": harga,
      };
}

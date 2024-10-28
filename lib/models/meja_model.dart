// To parse this JSON data, do
//
//     final meja = mejaFromJson(jsonString);

import 'dart:convert';

Meja mejaFromJson(String str) => Meja.fromJson(json.decode(str));

String mejaToJson(Meja data) => json.encode(data.toJson());

class Meja {
  int id;
  String nomorMeja;

  Meja({
    required this.id,
    required this.nomorMeja,
  });

  factory Meja.fromJson(Map<String, dynamic> json) => Meja(
        id: json["id"],
        nomorMeja: json["nomor_meja"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_meja": nomorMeja,
      };
}

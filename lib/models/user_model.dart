// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String namaUser;
  String role;
  String username;
  String password;

  User({
    required this.id,
    required this.namaUser,
    required this.role,
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        namaUser: json["nama_user"],
        role: json["role"],
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        '"id"': id,
        '"nama_user"': '"$namaUser"',
        '"role"': '"$role"',
        '"username"': '"$username"',
        '"password"': '"$password"',
      };
}

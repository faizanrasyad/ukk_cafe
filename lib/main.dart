import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/pages/admin/home_admin.dart';
import 'package:ukk_cafe/pages/admin/kelola_meja.dart';
import 'package:ukk_cafe/pages/admin/kelola_menu.dart';
import 'package:ukk_cafe/pages/admin/kelola_user.dart';
import 'package:ukk_cafe/pages/admin/tambah_meja.dart';
import 'package:ukk_cafe/pages/admin/tambah_menu.dart';
import 'package:ukk_cafe/pages/admin/tambah_user.dart';
import 'package:ukk_cafe/pages/login.dart';

void main() {
  runApp(GlobalLoaderOverlay(
      child: MaterialApp(
    title: "Wikusama Cafe",
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => Login(),
      '/homeAdmin': (context) => HomeAdmin(),
      '/kelolaMeja': (context) => KelolaMeja(),
      '/kelolaUser': (context) => KelolaUser(),
      '/kelolaMenu': (context) => KelolaMenu(),
      '/tambahMeja': (context) => TambahMeja(),
      '/tambahUser': (context) => TambahUser(),
      '/tambahMenu': (context) => TambahMenu(),
    },
  )));
}

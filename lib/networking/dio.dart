import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_cafe/models/user_model.dart';

class DioClient {
  // Declare the baseUrl (API Url)
  final baseUrl = "http://192.168.1.23:5101/api";
  late String token;

  // Setup your Dio Settings
  Future<Dio> getClient() async {
    Dio dio = new Dio();

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token').toString().trim();

    // Headers
    Map<String, String> headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    dio.options.headers = headers;

    // Timeout
    dio.options.connectTimeout = Duration(seconds: 20);
    dio.options.receiveTimeout = Duration(seconds: 10);

    // Interceptors (Logging for easier maintenance)
    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));

    return dio;
  }
}

class DioCommands {
  Future<void> setToken(String jsonUser) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio
          .post("${DioClient().baseUrl}/auth/generate-token", data: jsonUser);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> addMeja(String nomorMeja) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.post("${DioClient().baseUrl}/mejas",
          data: {'nomor_meja': nomorMeja});
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> editMeja(int mejaId, String nomorMeja) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.put("${DioClient().baseUrl}/mejas/$mejaId",
          data: {'id': mejaId, 'nomor_meja': nomorMeja});
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> addUser(
      String namaUser, String role, String username, String password) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.post("${DioClient().baseUrl}/users", data: {
        'nama_user': namaUser,
        'role': role,
        'username': username,
        'password': password
      });
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> editUser(int userId, String namaUser, String role,
      String username, String password) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response =
          await dio.put("${DioClient().baseUrl}/users/$userId", data: {
        'id': userId,
        'nama_user': namaUser,
        'role': role,
        'username': username,
        'password': password
      });
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> addMenu(String nama_menu, String jenis, String deskripsi,
      String gambar, int harga) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.post("${DioClient().baseUrl}/menus", data: {
        'nama_menu': nama_menu,
        'jenis': jenis,
        'deskripsi': deskripsi,
        'gambar': gambar,
        'harga': harga
      });
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> editMenu(int menuId, String nama_menu, String jenis,
      String deskripsi, String gambar, int harga) async {
    Dio dio = await DioClient().getClient();

    try {
      Response response =
          await dio.put("${DioClient().baseUrl}/menus/$menuId", data: {
        'id': menuId,
        'nama_menu': nama_menu,
        'jenis': jenis,
        'deskripsi': deskripsi,
        'gambar': gambar,
        'harga': harga
      });
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }
}

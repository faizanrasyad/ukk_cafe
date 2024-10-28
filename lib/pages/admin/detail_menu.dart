import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/menu_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/pages/admin/tambah_menu.dart';
import 'package:ukk_cafe/res/warna.dart';

class DetailMenu extends StatefulWidget {
  final Menu menu;
  const DetailMenu({super.key, required this.menu});

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  late Menu menu;
  @override
  void initState() {
    super.initState();
    menu = widget.menu;
  }

  // DELETE Menu
  Future<void> deleteMenu() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response =
          await dio.delete("${DioClient().baseUrl}/menus/${menu.id}");
      Navigator.pop(context);
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> hapus() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Warna().redKfc,
            title: Text(
              "Hapus Menu",
              style: TextStyle(color: Colors.white),
            ),
            content: Text("Menu '${menu.namaMenu}' akan dihapus dari database.",
                style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Batal",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () async {
                    context.loaderOverlay.show();
                    await deleteMenu();
                    context.loaderOverlay.hide();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Hapus",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  Future<void> getUserById() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response =
          await dio.get("${DioClient().baseUrl}/menus/${menu.id}");
      setState(() {
        menu = Menu.fromJson(response.data);
      });
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.loaderOverlay.hide();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Warna().redKfc,
        title: Text(
          "Detail Menu",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: Expanded(
        child: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(
                    child: Image.network(menu.gambar),
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  menu.namaMenu,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  menu.jenis[0].toUpperCase() +
                      menu.jenis.substring(1).toLowerCase(),
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Rp. ${menu.harga}",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Warna().redKfc,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  menu.deskripsi,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TambahMenu(
                                    menu: menu,
                                  ))).then((value) => getUserById());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Edit",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      hapus();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Hapus",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Warna().redKfc),
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

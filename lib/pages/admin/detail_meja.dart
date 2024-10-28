import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/meja_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/pages/admin/tambah_meja.dart';
import 'package:ukk_cafe/res/warna.dart';

class DetailMeja extends StatefulWidget {
  final Meja meja;
  const DetailMeja({super.key, required this.meja});

  @override
  State<DetailMeja> createState() => _DetailMejaState();
}

class _DetailMejaState extends State<DetailMeja> {
  late Meja meja;
  @override
  void initState() {
    super.initState();
    meja = widget.meja;
    getMejaById();
  }

  // DELETE Meja
  Future<void> deleteMeja() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response =
          await dio.delete("${DioClient().baseUrl}/mejas/${meja.id}");
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
              "Hapus Meja",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
                "Nomor meja '${meja.nomorMeja}' akan dihapus dari database.",
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
                    await deleteMeja();
                    context.loaderOverlay.hide();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Hapus",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  Future<void> getMejaById() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response =
          await dio.get("${DioClient().baseUrl}/mejas/${meja.id}");
      setState(() {
        meja = Meja.fromJson(response.data);
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
          "Detail Meja",
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
                    child: Image.network(
                      "https://static.vecteezy.com/system/resources/previews/015/159/469/original/wooden-round-table-isolated-free-vector.jpg",
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  meja.nomorMeja,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
                              builder: (context) => TambahMeja(
                                    meja: meja,
                                  ))).then((value) => getMejaById());
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

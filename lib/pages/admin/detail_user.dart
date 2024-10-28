import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/user_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/pages/admin/tambah_user.dart';
import 'package:ukk_cafe/res/warna.dart';

class DetailUser extends StatefulWidget {
  final User user;
  const DetailUser({super.key, required this.user});

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  late User user;
  @override
  void initState() {
    super.initState();
    user = widget.user;
    getUserById();
  }

  // DELETE User
  Future<void> deleteUser() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response =
          await dio.delete("${DioClient().baseUrl}/users/${user.id}");
      Navigator.pop(context);
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS : ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  Future<void> hapusUser() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Warna().redKfc,
            title: Text(
              "Hapus User",
              style: TextStyle(color: Colors.white),
            ),
            content: Text("User '${user.namaUser}' akan dihapus dari database.",
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
                    await deleteUser();
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
          await dio.get("${DioClient().baseUrl}/users/${user.id}");
      setState(() {
        user = User.fromJson(response.data);
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
          "Detail User",
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
                        "https://superawesomevectors.com/wp-content/uploads/2021/02/worker-vector-icon.jpg"),
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  user.namaUser,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.role[0].toUpperCase() +
                      user.role.substring(1).toLowerCase(),
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
                  "Username: ${user.username}",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Password: ${user.password}",
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
                              builder: (context) => TambahUser(
                                    user: user,
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
                      hapusUser();
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

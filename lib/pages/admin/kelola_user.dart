import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/user_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/pages/admin/detail_user.dart';
import 'package:ukk_cafe/pages/admin/tambah_user.dart';
import 'package:ukk_cafe/res/warna.dart';

class KelolaUser extends StatefulWidget {
  const KelolaUser({super.key});

  @override
  State<KelolaUser> createState() => _KelolaUserState();
}

class _KelolaUserState extends State<KelolaUser> {
  late List<User> userList;

  @override
  void initState() {
    userList = List.empty();
    getUsers();
    super.initState();
  }

  // GET Mejas
  Future<void> getUsers() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.get('${DioClient().baseUrl}/users');
      List<dynamic> jsonData = response.data;

      setState(() {
        userList = jsonData.map((e) => User.fromJson(e)).toList();
      });
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
      return e.response!.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.loaderOverlay.hide();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Kelola User",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Warna().redKfc,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambahUser')
              .then((value) => getUsers());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Warna().redKfc,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: userList.length < 1
                    ? Center(
                        child: Text("Tunggu sebentar..."),
                      )
                    : Column(
                        children: [
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 15),
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                splashFactory: NoSplash.splashFactory,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.network(
                                        "https://superawesomevectors.com/wp-content/uploads/2021/02/worker-vector-icon.jpg",
                                        width: 100,
                                      ),
                                      Text(
                                        userList[index].namaUser,
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailUser(
                                                  user: userList[index])))
                                      .then((value) => getUsers());
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/menu_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/pages/admin/detail_menu.dart';
import 'package:ukk_cafe/res/warna.dart';

class KelolaMenu extends StatefulWidget {
  const KelolaMenu({super.key});

  @override
  State<KelolaMenu> createState() => _KelolaMenuState();
}

class _KelolaMenuState extends State<KelolaMenu> {
  late List<Menu> menuList;

  @override
  void initState() {
    menuList = List.empty();
    getMenus();
    super.initState();
  }

  // GET Menus
  Future<void> getMenus() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.get('${DioClient().baseUrl}/menus');
      List<dynamic> jsonData = response.data;

      setState(() {
        menuList = jsonData.map((e) => Menu.fromJson(e)).toList();
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
          "Kelola Menu",
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
          Navigator.pushNamed(context, '/tambahMenu')
              .then((value) => getMenus());
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: menuList.length < 1
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
                            itemCount: menuList.length,
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
                                        menuList[index].gambar,
                                        width: 100,
                                      ),
                                      Text(
                                        menuList[index].namaMenu,
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailMenu(
                                                  menu: menuList[index])))
                                      .then((value) => getMenus());
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

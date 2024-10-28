import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_cafe/models/meja_model.dart';
import 'package:ukk_cafe/models/menu_model.dart';
import 'package:ukk_cafe/models/user_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/pages/admin/detail_meja.dart';
import 'package:ukk_cafe/pages/admin/detail_menu.dart';
import 'package:ukk_cafe/pages/admin/detail_user.dart';
import 'package:ukk_cafe/res/warna.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String name = "default";
  int menuLength = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    getMenus();
    getMejas();
    getUsers();
  }

  // Load Shared Preferences (Get logged-in user data)
  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name').toString();
  }

  List<Menu> menuList = [];
  List<User> userList = [];
  List<Meja> mejaList = [];

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

  // GET Users
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

  // GET Mejas
  Future<void> getMejas() async {
    Dio dio = await DioClient().getClient();

    try {
      Response response = await dio.get('${DioClient().baseUrl}/mejas');
      List<dynamic> jsonData = response.data;

      setState(() {
        mejaList = jsonData.map((e) => Meja.fromJson(e)).toList();
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

  void logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Warna().redKfc,
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Akun anda akan keluar dari aplikasi.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/');
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('rememberMe');
                prefs.remove('username');
                prefs.remove('password');
                prefs.remove('name');
                prefs.remove('id');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.loaderOverlay.hide();
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Warna().redKfc),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/person_icon_round.png",
                      width: 70,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )
                  ],
                )),
            ListTile(
              leading: Icon(
                Icons.fastfood,
                color: Warna().redKfc,
              ),
              title: Text("Kelola Menu"),
              onTap: () {
                Navigator.pushNamed(context, '/kelolaMenu')
                    .then((value) => getMenus());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.group,
                color: Warna().redKfc,
              ),
              title: Text("Kelola User"),
              onTap: () {
                Navigator.pushNamed(context, '/kelolaUser')
                    .then((value) => getUsers());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.table_restaurant,
                color: Warna().redKfc,
              ),
              title: Text("Kelola Meja"),
              onTap: () {
                Navigator.pushNamed(context, '/kelolaMeja')
                    .then((value) => getMejas());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(builder: (context) {
                        return IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(
                              Icons.fastfood,
                              color: Warna().redKfc,
                            ));
                      }),
                      Text(
                        "Hi, ${name}",
                        style: TextStyle(
                            color: Warna().redKfc,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      logout();
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Warna().redKfc,
                        fixedSize: Size(5, 5)),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              // Preview Menus
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Menu",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/kelolaMenu')
                          .then((value) => getMenus());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Kelola"),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 18,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: menuList.length < 1
                    ? Center(
                        child: Text("Data menu kosong!"),
                      )
                    : Column(
                        children: [
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 15),
                            itemCount: 4,
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
                            height: 4,
                          ),
                          Center(
                            child:
                                Text("dan ${menuList.length - 4} menu lainnya"),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
              ),
              // Preview Users
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "User",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/kelolaUser')
                          .then((value) => getUsers());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Kelola"),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 18,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: userList.length < 1
                    ? Center(
                        child: Text("Data user kosong!"),
                      )
                    : Column(
                        children: [
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 15),
                            itemCount: 4,
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
                            height: 4,
                          ),
                          Center(
                            child:
                                Text("dan ${userList.length - 4} user lainnya"),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
              ),
              // Preview Mejas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Meja",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/kelolaMeja')
                          .then((value) => getMejas());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Kelola"),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 18,
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: mejaList.length < 1
                    ? Center(
                        child: Text("Data meja kosong!"),
                      )
                    : Column(
                        children: [
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, crossAxisSpacing: 15),
                            itemCount: 4,
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
                                        "https://static.vecteezy.com/system/resources/previews/015/159/469/original/wooden-round-table-isolated-free-vector.jpg",
                                        width: 100,
                                      ),
                                      Text(
                                        "${mejaList[index].nomorMeja}",
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailMeja(
                                                  meja: mejaList[index])))
                                      .then((value) => getMejas());
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Center(
                            child:
                                Text("dan ${mejaList.length - 4} meja lainnya"),
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

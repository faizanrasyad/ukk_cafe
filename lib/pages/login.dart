import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukk_cafe/models/user_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/res/warna.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late bool isRemember;
  bool hidePass = true;

  String? _username;
  String? _password;
  bool _rememberMe = false;
  bool currentRememberMe = false;

  @override
  void initState() {
    // TODO: implement initState
    _loadPreferences();
    super.initState();
  }

  // Load Shared Preferences (SSO)
  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    var role = prefs.getString('role');
    setState(() {
      isRemember = prefs.getBool('rememberMe')!;
    });
    if (isRemember == true) {
      if (role == "admin") {
        Navigator.pushReplacementNamed(context, '/homeAdmin');
        return;
      }

      if (role == "kasir") {
        return;
      }

      if (role == "manajer") {
        return;
      }
    }
  }

  Future<void> login(
      String username, String password, BuildContext context) async {
    try {
      Dio dio = await DioClient().getClient();
      Response response = await dio.post("${DioClient().baseUrl}/login",
          queryParameters: {'username': username, 'password': password});

      int responseCode = response.statusCode!;

      if (responseCode != 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User tidak ditemukan")));
        userController.clear();
        passController.clear();
        return;
      }
      if (responseCode == 200) {
        User loggedUser = User.fromJson(response.data);
        String jsonUser = User(
                id: loggedUser.id,
                namaUser: loggedUser.namaUser,
                password: loggedUser.password,
                role: loggedUser.role,
                username: loggedUser.username)
            .toJson()
            .toString();
        await DioCommands().setToken(jsonUser);
        print("Logged In User: $loggedUser");
        if (loggedUser.id != null) {
          // Preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', loggedUser.username);
          await prefs.setString('password', loggedUser.password);
          await prefs.setString('name', loggedUser.namaUser);
          await prefs.setInt('id', loggedUser.id);
          await prefs.setString('role', loggedUser.role);
          await prefs.setBool('rememberMe', currentRememberMe);

          print("Berhasil Log In!");
          print("Prefs Name: ${prefs.getString('name')}");

          var role = loggedUser.role;

          if (role == "admin") {
            Navigator.pushReplacementNamed(context, '/homeAdmin');
            return;
          }

          if (role == "kasir") {
            return;
          }

          if (role == "manajer") {
            return;
          }
        } else {
          print("Gagal Memasukkan Ke loggedUser");
        }
      }
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Dio Error! STATUS: ${e.response?.statusCode}');
      } else {
        debugPrint(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Warna().redKfc),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Masukkan data yang sesuai untuk login.',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: TextFormField(
                                controller: userController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    labelText: 'Username',
                                    prefixIcon: Icon(Icons.person,
                                        color: Warna().redKfc)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Username can't be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(),
                              child: TextFormField(
                                controller: passController,
                                obscureText: hidePass,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    labelText: 'Password',
                                    prefixIcon:
                                        Icon(Icons.key, color: Warna().redKfc),
                                    suffixIcon: InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      child: Icon(
                                        hidePass == true
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Warna().redKfc,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          hidePass = !hidePass;
                                        });
                                      },
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password can't be empty";
                                  }
                                  if (value.length < 5) {
                                    return "Password must have 5 characters minimum";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: currentRememberMe,
                                  onChanged: (bool? value) async {
                                    setState(() {
                                      currentRememberMe = value!;
                                    });
                                  },
                                  activeColor: Warna().redKfc,
                                ),
                                Text(
                                  'Remember Me',
                                  style: TextStyle(color: Warna().redKfc),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    login(userController.text,
                                        passController.text, context);
                                    context.loaderOverlay.show();
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    print(
                                        "Prefs Username : ${prefs.getString('username')}");
                                    print(
                                        "Prefs Password : ${prefs.getString('password')}");
                                    print(
                                        "Prefs Name : ${prefs.getString('name')}");
                                    print(
                                        "Prefs Remember Me : ${prefs.getBool('rememberMe')}");
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Warna().redKfc,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(150, 50)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

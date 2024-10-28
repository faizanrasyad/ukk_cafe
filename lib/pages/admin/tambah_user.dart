import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/user_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/res/warna.dart';

class TambahUser extends StatefulWidget {
  final User? user;
  const TambahUser({super.key, this.user});

  @override
  State<TambahUser> createState() => _TambahUserState();
}

class _TambahUserState extends State<TambahUser> {
  TextEditingController namaCont = new TextEditingController();
  TextEditingController userCont = new TextEditingController();
  TextEditingController passCont = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  late User? user;
  bool hidePass = true;
  String role = "";
  List<String> roleList = ['admin', 'kasir', 'manajer'];

  @override
  void initState() {
    super.initState();
    user = widget.user;
    if (user != null) {
      namaCont.text = user!.namaUser;
      userCont.text = user!.username;
      passCont.text = user!.password;
      role = user!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: user == null
            ? Text(
                "Tambah User",
                style: TextStyle(color: Colors.white),
              )
            : Text(
                "Edit User",
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
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama",
                          style: TextStyle(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: namaCont,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              hintText: "Nama user...",
                              hintStyle:
                                  TextStyle(fontWeight: FontWeight.normal),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Warna().redKfc,
                              )),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Nama user tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Username",
                          style: TextStyle(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: userCont,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              hintText: "Username...",
                              hintStyle:
                                  TextStyle(fontWeight: FontWeight.normal),
                              prefixIcon: Icon(
                                Icons.tag,
                                color: Warna().redKfc,
                              )),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Username tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: passCont,
                          obscureText: hidePass,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            hintText: "Password...",
                            hintStyle: TextStyle(fontWeight: FontWeight.normal),
                            prefixIcon: Icon(
                              Icons.key,
                              color: Warna().redKfc,
                            ),
                            suffixIcon: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              child: Icon(hidePass == true
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onTap: () {
                                setState(() {
                                  hidePass = !hidePass;
                                });
                              },
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Role",
                          style: TextStyle(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        DropdownButtonFormField2<String>(
                          value: user != null ? user!.role : null,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          hint: const Text(
                            'Pilih role...',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: roleList
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Pilih satu role';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            role = value.toString();
                          },
                          onSaved: (value) {
                            role = value.toString();
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Warna().redKfc,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: user == null
                                ? () async {
                                    context.loaderOverlay.show();
                                    await DioCommands().addUser(namaCont.text,
                                        role, userCont.text, passCont.text);
                                    Navigator.pop(context);
                                  }
                                : () async {
                                    context.loaderOverlay.show();
                                    await DioCommands().editUser(
                                        user!.id,
                                        namaCont.text,
                                        role,
                                        userCont.text,
                                        passCont.text);
                                    Navigator.pop(context);
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  user == null ? Icons.add : Icons.edit,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  user == null ? "Tambah" : "Edit",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    user == null ? Colors.green : Colors.blue),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              namaCont.clear();
                              userCont.clear();
                              passCont.clear();
                              role = "";
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Batal",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Warna().redKfc,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}

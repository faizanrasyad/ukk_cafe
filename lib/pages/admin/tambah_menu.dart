import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/menu_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/res/warna.dart';
import 'package:http/http.dart' as http;

class TambahMenu extends StatefulWidget {
  final Menu? menu;
  const TambahMenu({super.key, this.menu});

  @override
  State<TambahMenu> createState() => _TambahMenuState();
}

class _TambahMenuState extends State<TambahMenu> {
  TextEditingController namaCont = new TextEditingController();
  TextEditingController descCont = new TextEditingController();
  TextEditingController hargaCont = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  String jenis = "";
  List<String> jenisList = ['makanan', 'minuman'];

  late Menu? menu;
  @override
  void initState() {
    super.initState();
    menu = widget.menu;
    if (menu != null) {
      descCont.text = menu!.deskripsi;
      namaCont.text = menu!.namaMenu;
      hargaCont.text = menu!.harga.toString();
      jenis = menu!.jenis;
      imageUrl = menu!.gambar;
    }
  }

  XFile? image;
  String? imageUrl;

  Future<void> pickImage(BuildContext context) async {
    try {
      XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      context.loaderOverlay.show();

      // Null Checking
      if (pickedImage == null) {
        context.loaderOverlay.hide();
        return;
      }

      var imageFile = File(pickedImage.path);
      int fileSize = await imageFile.length();
      int maxFileSizeInBytes = 5 * 1024 * 1024;

      // File Size Checking (Must be less than 5 MB [Mega Bytes] )
      if (fileSize >= maxFileSizeInBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Maksimal ukuran gambar 5 MB!")));
        context.loaderOverlay.hide();
        return;
      }

      setState(() {
        image = pickedImage;
      });
      context.loaderOverlay.hide();
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    if (image != null) {
      // Upload Image
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dcnmqlrf8/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'f4d8bnxj'
        ..files.add(await http.MultipartFile.fromPath('file', image!.path));

      context.loaderOverlay.show();

      final response = await request.send();

      context.loaderOverlay.hide();

      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        String finalUrl;
        setState(() {
          finalUrl = jsonMap['url'];
          imageUrl = finalUrl;
          print("Image URL $imageUrl");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: menu == null
            ? Text(
                'Tambah Menu',
                style: TextStyle(color: Colors.white),
              )
            : Text(
                'Edit Menu',
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
                        Text("Nama"),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: namaCont,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              hintText: "Nama menu...",
                              hintStyle:
                                  TextStyle(fontWeight: FontWeight.normal),
                              prefixIcon: Icon(
                                Icons.fastfood,
                                color: Warna().redKfc,
                              )),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Nama menu tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Jenis",
                          style: TextStyle(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        DropdownButtonFormField2<String>(
                          value: menu != null ? menu!.jenis : null,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          hint: const Text(
                            'Pilih jenis menu...',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          items: jenisList
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
                              return 'Pilih satu jenis menu';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            jenis = value.toString();
                          },
                          onSaved: (value) {
                            jenis = value.toString();
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
                        Text("Harga"),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: hargaCont,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              hintText: "Harga menu...",
                              hintStyle:
                                  TextStyle(fontWeight: FontWeight.normal),
                              prefixIcon: Icon(
                                Icons.monetization_on,
                                color: Warna().redKfc,
                              )),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Harga tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text("Deskripsi"),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: descCont,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              hintText: "Deskripsi menu...",
                              hintStyle:
                                  TextStyle(fontWeight: FontWeight.normal),
                              prefixIcon: Icon(
                                Icons.description,
                                color: Warna().redKfc,
                              )),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Deskripsi tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text('Gambar'),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              pickImage(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  menu == null
                                      ? image == null
                                          ? "Tambahkan Gambar"
                                          : "Ganti Gambar"
                                      : "Ganti Gambar",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Warna().redKfc,
                            ),
                          ),
                        ),
                        Container(
                            child: image != null
                                ? Image.file(File(image!.path))
                                : menu != null
                                    ? Image.network(menu!.gambar)
                                    : Center(
                                        child: Text("Pilih gambar"),
                                      )),
                        SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: menu == null
                                ? () async {
                                    context.loaderOverlay.show();
                                    uploadImage(context);
                                    print("Nama Menu: ${namaCont.text}");
                                    print("Deskripsi Menu: ${descCont.text}");
                                    print("Jenis Menu: ${jenis}");
                                    print("ImageUrl Menu: ${imageUrl}");
                                    print(
                                        "Harga Menu: ${int.parse(hargaCont.text)}");
                                    await DioCommands().addMenu(
                                        namaCont.text,
                                        jenis,
                                        descCont.text,
                                        imageUrl!,
                                        int.parse(hargaCont.text));
                                    Navigator.pop(context);
                                  }
                                : () async {
                                    context.loaderOverlay.show();
                                    if (imageUrl != menu!.gambar) {
                                      uploadImage(context);
                                    }
                                    await DioCommands().editMenu(
                                        menu!.id,
                                        namaCont.text,
                                        jenis,
                                        descCont.text,
                                        imageUrl!,
                                        int.parse(hargaCont.text));
                                    Navigator.pop(context);
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  menu == null ? Icons.add : Icons.edit,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  menu == null ? "Tambah" : "Edit",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    menu == null ? Colors.green : Colors.blue),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              namaCont.clear();
                              jenis = "";
                              descCont.clear();
                              hargaCont.clear();
                              imageUrl = "";
                              Navigator.pop(context);
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

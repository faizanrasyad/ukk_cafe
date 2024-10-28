import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/meja_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/res/warna.dart';

class TambahMeja extends StatefulWidget {
  final Meja? meja;
  const TambahMeja({super.key, this.meja});

  @override
  State<TambahMeja> createState() => _TambahMejaState();
}

class _TambahMejaState extends State<TambahMeja> {
  TextEditingController mejaCont = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  late Meja? meja;

  @override
  void initState() {
    super.initState();
    meja = widget.meja;
    if (meja != null) {
      mejaCont.text = meja!.nomorMeja;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: meja == null
            ? Text(
                "Tambah Meja",
                style: TextStyle(color: Colors.white),
              )
            : Text(
                "Edit Meja",
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
                        "Nomor Meja",
                        style: TextStyle(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: mejaCont,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            hintText: "Meja 1",
                            hintStyle: TextStyle(fontWeight: FontWeight.normal),
                            prefixIcon: Icon(
                              Icons.table_restaurant,
                              color: Warna().redKfc,
                            )),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Nomor Meja tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: meja == null
                      ? () async {
                          context.loaderOverlay.show();
                          await DioCommands().addMeja(mejaCont.text);
                          Navigator.pop(context);
                        }
                      : () async {
                          context.loaderOverlay.show();
                          await DioCommands().editMeja(meja!.id, mejaCont.text);
                          Navigator.pop(context);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        meja == null ? Icons.add : Icons.edit,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        meja == null ? "Tambah" : "Edit",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          meja == null ? Colors.green : Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                    mejaCont.text == "";
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
        ),
      )),
    );
  }
}

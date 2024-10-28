import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ukk_cafe/models/meja_model.dart';
import 'package:ukk_cafe/networking/dio.dart';
import 'package:ukk_cafe/pages/admin/detail_meja.dart';
import 'package:ukk_cafe/res/warna.dart';

class KelolaMeja extends StatefulWidget {
  const KelolaMeja({super.key});

  @override
  State<KelolaMeja> createState() => _KelolaMejaState();
}

class _KelolaMejaState extends State<KelolaMeja> {
  late List<Meja> mejaList;
  late String name;
  late int mejaLength;

  @override
  void initState() {
    mejaList = List.empty();
    getMejas();
    mejaLength = mejaList.length;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    context.loaderOverlay.hide();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Kelola Meja",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Warna().redKfc,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambahMeja')
              .then((value) => getMejas());
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                child: mejaList.length < 1
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
                            itemCount: mejaList.length,
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

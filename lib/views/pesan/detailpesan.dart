import 'package:flutter/material.dart';
import 'package:foto_app/models/pesan_model.dart';
import 'package:foto_app/views/home.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

// ignore: must_be_immutable
class DetailPesan extends StatefulWidget {
  PesanModel pesan;
  int index;

  DetailPesan({super.key, required this.pesan, required this.index});

  @override
  DetailPesanState createState() => DetailPesanState();
}

class DetailPesanState extends State<DetailPesan> {
  bool? isUserLogin;

  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Projek?'),
          content: Text(
              "Apakah anda yakin ingin menghapus pesan '${widget.pesan.nama}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context, true);
                deleteData(widget.pesan);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    getStorageToken();
  }

  void getStorageToken() async {
    String token = await handle_storage.getDataStorage('token');

    setState(() {
      isUserLogin = token != '' && token != "null";
    });
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void deleteData(PesanModel pesan) async {
    dynamic body = {"id": pesan.id.toString()};

    var url = "${host.BASE_URL}pesan/delete";

    handle_request.postData(Uri.parse(url), body).then((response) {
      // Navigator.pop(context, true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String createDate = widget.pesan.createdAt as String;

    var now = DateTime.now().toString();
    var date = createDate != ''
        ? DateTime.parse(createDate.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAt = DateFormat('dd MMMM yyy').format(date);

    return Scaffold(
        appBar: AppBar(
            title: Text(
              "${widget.pesan.nama}",
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            shadowColor: Colors.transparent),
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Card(
                    color: Colors.white,
                    child: Center(
                        child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                      ),
                      Center(
                        child: Text(
                          widget.pesan.nama as String,
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Row(
                                children: [
                                  const Text(
                                    "Nama            : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.pesan.nama}",
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Fotografer    : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pesan.fotografer as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Videografer  : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pesan.videografer as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Dibuat Tgl.    : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    createdAt,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      Visibility(
                          visible: isUserLogin == true,
                          child: Row(children: [
                            TextButton(
                              onPressed: () => confirmDelete(),
                              child: const Text("HAPUS",
                                  style: TextStyle(color: Colors.red)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/edit_pesan',
                                  arguments: {"pesan": widget.pesan}),
                              child: const Text("EDIT",
                                  style: TextStyle(color: Colors.green)),
                            ),
                          ])),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                    ]))))));
  }
}

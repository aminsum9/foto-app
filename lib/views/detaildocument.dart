import 'package:foto_app/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;

// ignore: must_be_immutable
class DetailDocument extends StatefulWidget {
  DocumentModel document;
  int index;

  DetailDocument({super.key, required this.document, required this.index});

  @override
  DetailDocumentState createState() => DetailDocumentState();
}

class DetailDocumentState extends State<DetailDocument> {
  DocumentModel? transData;
  List<Widget> detailTransaksi = [];

  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Transaksi?'),
          content: Text(
              "Apakah anda yakin ingin menghapus dokumen '${widget.document.judul}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
              onPressed: () {
                deleteData();
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
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void deleteData() async {
    dynamic body = {"page": 1, "paging": 10};

    var url = "${host.BASE_URL}document/delete";

    handle_request.postData(Uri.parse(url), body).then((response) =>
        {Navigator.pop(context, true), Navigator.pop(context, true)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "${widget.document.judul}",
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
                      Text(
                        widget.document.judul as String,
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Ketegori         : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.document.kategori}",
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Link     : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.document.link as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Foto           : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.document.foto as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Dibuat oleh :",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.document.pembuat}",
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Ringkasan      : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.document.ringkasan as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              )
                            ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      TextButton(
                        onPressed: () => confirmDelete(),
                        child: const Text("HAPUS",
                            style: TextStyle(color: Colors.red)),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: detailTransaksi,
                      ),
                    ]))))));
  }
}
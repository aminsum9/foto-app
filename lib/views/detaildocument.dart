import 'package:foto_app/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/views/document.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

// ignore: must_be_immutable
class DetailDocument extends StatefulWidget {
  DocumentModel document;
  int index;

  DetailDocument({super.key, required this.document, required this.index});

  @override
  DetailDocumentState createState() => DetailDocumentState();
}

class DetailDocumentState extends State<DetailDocument> {
  DocumentModel? documentData;
  List<Widget> fotoList = [];
  bool? isUserLogin;

  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Dokument?'),
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
                Navigator.pop(context, true);
                deleteData(widget.document.id);
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

  void deleteData(id) async {
    dynamic body = {"id": id.toString()};

    var url = "${host.BASE_URL}document/delete";

    handle_request.postData(Uri.parse(url), body).then((response) {
      // (context.findAncestorStateOfType<DocumentState>())?.refreshData();
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    String documentTanggalData = widget.document.tanggal as String;
    String createDate = widget.document.createdAt as String;

    var now = DateTime.now().toString();

    var documentTanggalParse = documentTanggalData != ''
        ? DateTime.parse(documentTanggalData.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String documentTanggal =
        DateFormat('dd MMMM yyy').format(documentTanggalParse);

    var date = createDate != ''
        ? DateTime.parse(createDate.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAt = DateFormat('dd MMMM yyy').format(date);

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Ketegori     : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.document.kategoriData?.kategori ??
                                        "",
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Link            : ",
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
                                    "Ringkasan    : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.document.ringkasan as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Dibuat oleh   : ",
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
                                    "Tanggal      : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    documentTanggal,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Dibuat Tgl. : ",
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
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Visibility(
                                  visible: widget.document.foto != null &&
                                      widget.document.foto != '',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Foto:'),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 5)),
                                      Image.network(
                                        '${host.BASE_URL_IMG}document/${widget.document.foto}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  )),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Visibility(
                                  visible: widget.document.foto1 != null &&
                                      widget.document.foto1 != '',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Foto 1:'),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 5)),
                                      Image.network(
                                        '${host.BASE_URL_IMG}document/${widget.document.foto1}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  )),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Visibility(
                                  visible: widget.document.foto2 != null &&
                                      widget.document.foto2 != '',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Foto 2:'),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 5)),
                                      Image.network(
                                        '${host.BASE_URL_IMG}document/${widget.document.foto2}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  )),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Visibility(
                                  visible: widget.document.foto3 != null &&
                                      widget.document.foto3 != '',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Foto 3:'),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 5)),
                                      Image.network(
                                        '${host.BASE_URL_IMG}document/${widget.document.foto3}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  )),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Visibility(
                                  visible: widget.document.foto4 != null &&
                                      widget.document.foto4 != '',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Foto 4:'),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 5)),
                                      Image.network(
                                        '${host.BASE_URL_IMG}document/${widget.document.foto4}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  )),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Visibility(
                                  visible: widget.document.foto5 != null &&
                                      widget.document.foto5 != '',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Foto 5:'),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 5)),
                                      Image.network(
                                        '${host.BASE_URL_IMG}document/${widget.document.foto5}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  )),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Visibility(
                                  visible: widget.document.foto6 != null &&
                                      widget.document.foto6 != '',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Foto 6:'),
                                      const Padding(
                                          padding: EdgeInsets.only(bottom: 5)),
                                      Image.network(
                                        '${host.BASE_URL_IMG}document/${widget.document.foto6}',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  )),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                            ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      Visibility(
                          visible: isUserLogin == true,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () => confirmDelete(),
                                child: const Text("HAPUS",
                                    style: TextStyle(color: Colors.red)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/edit_document',
                                    arguments: {'document': widget.document}),
                                child: const Text("EDIT",
                                    style: TextStyle(color: Colors.green)),
                              ),
                            ],
                          )),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: fotoList,
                      ),
                    ]))))));
  }
}

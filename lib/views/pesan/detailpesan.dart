import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foto_app/models/pesan_model.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';

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
  bool? isAdmin;

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
    requestPermission();
  }

  void requestPermission() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      print(' manage storage granted');
    } else {
      print(' manage storage not granted');
    }
  }

  void getStorageToken() async {
    String token = await handle_storage.getDataStorage('token');
    String roleUsers = await handle_storage.getDataStorage('role_users');

    setState(() {
      isUserLogin = token != '' && token != "null";
      isAdmin = roleUsers == 'Administrator';
    });
  }

  void deleteData(PesanModel pesan) async {
    dynamic body = {"id": pesan.id.toString()};

    var url = "${host.BASE_URL}pesan/delete";

    handle_request.postData(Uri.parse(url), body).then((response) {
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    });
  }

  void downloadFile(String fileSurat) async {
    var url =
        "${host.BASE_URL}pesan/file-surat?file-surat=${widget.pesan.file_surat}";

    var response = await handle_request.getData(Uri.parse(url));

    if (response.statusCode == 200) {
      var storageDirectory = await ExternalPath.getExternalStorageDirectories();
      var directoryDownload = ExternalPath.DIRECTORY_DOWNLOADS;

      var filePath = path.join(
          "${storageDirectory.first.toString()}/$directoryDownload/",
          fileSurat);

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      Fluttertoast.showToast(
          msg:
              "Berhasil mendownload file surat, tersimpan di penyimpanan internal 'Download'",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      showDialog<void>(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Hapus Projek?'),
            content: const Text("Apakah anda yakin ingin membuka file?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text("TIDAK", style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                child: const Text('BUKA', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context, true);
                  OpenFile.open(filePath);
                },
              ),
            ],
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Gagal mendownload file surat!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    String tanggalAwalData = widget.pesan.tanggal_awal as String;
    String tanggalAkhirData = widget.pesan.tanggal_akhir as String;

    String createDate = widget.pesan.createdAt as String;

    var now = DateTime.now().toString();

    var tanggalAwalDate = tanggalAwalData != ''
        ? DateTime.parse(tanggalAwalData.split(' ')[0])
        : DateTime.parse(now.split('T')[0]);
    String tanggalAwal = DateFormat('dd MMMM yyy').format(tanggalAwalDate);

    var tanggalAkhirDate = tanggalAkhirData != ''
        ? DateTime.parse(tanggalAkhirData.split(' ')[0])
        : DateTime.parse(now.split('T')[0]);
    String tanggalAkhir = DateFormat('dd MMMM yyy').format(tanggalAkhirDate);

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
                        padding: EdgeInsets.only(top: 10.0),
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
                                    "No. Surat : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.pesan.nomor_surat}",
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Satuan Kerja : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.pesan.satuan_kerja}",
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
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
                                    "Nama Projek : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.pesan.nama_project}",
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Tanggal Awal : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    tanggalAwal,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Waktu Awal : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pesan.waktu_awal as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Tanggal Akhir : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    tanggalAkhir,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Waktu Akhir : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pesan.waktu_akhir as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Tempat : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pesan.tempat as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Acara : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pesan.acara as String,
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
                                    "Status  : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pesan.status as String,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Link  : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pesan.link as String,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "File Surat : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.pesan.file_surat}",
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 17.0),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  GestureDetector(
                                    onTap: () => downloadFile(
                                        widget.pesan.file_surat.toString()),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.blueAccent)),
                                      child: const Text(
                                        'download file',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      Visibility(
                          visible: isUserLogin == true && isAdmin == true,
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

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
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    });
  }

  // nomor_surat,
  // file_surat,
  // satuan_kerja,
  // nama,
  // nama_project,
  // tanggal_awal,
  // waktu_awal,
  // tanggal_akhir,
  // waktu_akhir,
  // tempat,
  // acara,
  // fotografer,
  // videografer,
  // status,
  // link,
  // users_id,

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

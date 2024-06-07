import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

class AddPesan extends StatefulWidget {
  const AddPesan({super.key});
  @override
  AddPesanState createState() => AddPesanState();
}

class AddPesanState extends State<AddPesan> {
  dynamic dataUser;

  DateTime tanggalAwal = DateTime.now();
  TimeOfDay waktuAwal = TimeOfDay.now();
  DateTime tanggalAkhir = DateTime.now();
  TimeOfDay waktuAkhir = TimeOfDay.now();

  TextEditingController controllerNomorSurat = TextEditingController(text: "");
  TextEditingController controllerNamaSurat = TextEditingController(text: "");
  TextEditingController controllerSatuanKerja = TextEditingController(text: "");
  TextEditingController controllerNamaProject = TextEditingController(text: "");
  TextEditingController controllerTempat = TextEditingController(text: "");
  TextEditingController controllerAcara = TextEditingController(text: "");
  TextEditingController controllerFotografer = TextEditingController(text: "");
  TextEditingController controllerVideografer = TextEditingController(text: "");
  TextEditingController controllerLink = TextEditingController(text: "");

  // this.nomor_surat,
  // this.file_surat,
  // this.satuan_kerja,
  // this.nama,
  // this.nama_project,
  // this.tanggal_awal,
  // this.waktu_awal,
  // this.tanggal_akhir,
  // this.waktu_akhir,
  // this.tempat,
  // this.acara,
  // this.fotografer,
  // this.videografer,
  // this.status,
  // this.link,
  // this.users_id,

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void getDataUser() async {
    String user = await handle_storage.getDataStorage('user');

    setState(() {
      dataUser = jsonDecode(user);
    });
  }

  void addDataPesan(BuildContext context) async {
    var token = await handle_storage.getDataStorage('token');

    var url = Uri.parse("${host.BASE_URL}pesan/add");

    var request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = 'Bearer $token';
    request.headers["Content-Type"] = 'multipart/form-data';

    request.fields['nomor_surat'] = controllerNomorSurat.text;
    request.fields['file_surat'] = ''; //
    request.fields['satuan_kerja'] = controllerSatuanKerja.text;
    request.fields['nama'] = controllerNamaSurat.text;
    request.fields['nama_project'] = controllerNamaProject.text;

    // tanggal_awal,
    request.fields['tanggal_awal'] = tanggalAwal.toString().split('.')[0];
    // waktu_awal,
    request.fields['waktu_awal'] = waktuAwal.toString();
    // tanggal_akhir,
    request.fields['tanggal_akhir'] = tanggalAwal.toString().split('.')[0];
    // waktu_akhir,
    request.fields['waktu_akhir'] = waktuAkhir.toString();

    request.fields['tempat'] = controllerTempat.text;
    request.fields['acara'] = controllerAcara.text;
    request.fields['fotografer'] = controllerFotografer.text.toString();
    request.fields['videografer'] = controllerVideografer.text.toString();
    // --- status
    request.fields['link'] = controllerLink.text.toString();
    request.fields['user_id'] = dataUser['id'].toString();

    final response = await request.send();

    final respBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decodedMap = await json.decode(respBody);

      if (decodedMap['success']) {
        Fluttertoast.showToast(
            msg: "Berhasil menambah pesan baru.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else if (decodedMap['message'] != null) {
        Fluttertoast.showToast(
            msg: "Gagal menambah pesan!, ${decodedMap['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Gagal menambah pesan!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> selectTanggalAwal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalAwal,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != tanggalAwal) {
      setState(() {
        tanggalAwal = picked;
      });
    }
  }

  Future<void> selectWaktuAwal() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime != null && selectedTime != waktuAwal) {
      setState(() {
        waktuAwal = selectedTime;
      });
    }
  }

  Future<void> selectTanggalAkhir() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalAkhir,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != tanggalAkhir) {
      setState(() {
        tanggalAkhir = picked;
      });
    }
  }

  Future<void> selectWaktuAkhir() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime != null && selectedTime != waktuAkhir) {
      setState(() {
        waktuAkhir = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Tambah Pesan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controllerNomorSurat,
                  decoration: InputDecoration(
                      hintText: "masukkan nomor surat",
                      labelText: "Nomor Surat",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerSatuanKerja,
                  decoration: InputDecoration(
                      hintText: "masukkan satuan Kerja",
                      labelText: "Satuan Kerja",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerNamaSurat,
                  decoration: InputDecoration(
                      hintText: "masukkan nama surat",
                      labelText: "Nama Surat",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerNamaProject,
                  decoration: InputDecoration(
                      hintText: "masukkan nama projek",
                      labelText: "Nama Projek",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextButton(
                  onPressed: () {
                    selectTanggalAwal();
                  },
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14, top: 10, right: 14, bottom: 10),
                          child: Text(
                              "Tanggal Awal: ${tanggalAwal.toString().split(' ')[0]}"))),
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                TextButton(
                  onPressed: () {
                    selectWaktuAwal();
                  },
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14, top: 10, right: 14, bottom: 10),
                          child: Text(
                              "Waktu Awal: ${waktuAwal.hour}:${waktuAwal.minute}"))),
                ),
                const Padding(
                  padding: EdgeInsets.all(2.0),
                ),
                TextButton(
                  onPressed: () {
                    selectTanggalAwal();
                  },
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14, top: 10, right: 14, bottom: 10),
                          child: Text(
                              "Tanggal Akhir: ${tanggalAkhir.toString().split(' ')[0]}"))),
                ),
                const Padding(
                  padding: EdgeInsets.all(2.0),
                ),
                TextButton(
                  onPressed: () {
                    selectWaktuAkhir();
                  },
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14, top: 10, right: 14, bottom: 10),
                          child: Text(
                              "Waktu Akhir: ${waktuAkhir.hour}:${waktuAkhir.minute}"))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerTempat,
                  decoration: InputDecoration(
                      hintText: "masukkan tempat",
                      labelText: "Tempat",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerAcara,
                  decoration: InputDecoration(
                      hintText: "masukkan acara",
                      labelText: "Acara",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerFotografer,
                  decoration: InputDecoration(
                      hintText: "masukkan fotografer",
                      labelText: "Fotografer",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerVideografer,
                  decoration: InputDecoration(
                      hintText: "masukkan videografer",
                      labelText: "Videografer",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerLink,
                  decoration: InputDecoration(
                      hintText: "masukkan link",
                      labelText: "Link",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
              ],
            ),
          ])),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        child: TextButton(
          onPressed: () {
            addDataPesan(context);
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: colors.primary,
              padding: const EdgeInsets.all(15)),
          child:
              const Text("Tambah Pesan", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

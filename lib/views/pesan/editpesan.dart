import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foto_app/functions/convert_time.dart';
import 'package:foto_app/models/pesan_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

class EditPesan extends StatefulWidget {
  const EditPesan({super.key});
  @override
  EditPesanState createState() => EditPesanState();
}

class EditPesanState extends State<EditPesan> {
  dynamic dataUser;

  FilePickerResult? fileSurat;
  String fileSuratName = '';

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

  String pesanId = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      getPrevPageData();
      getDataUser();
    });
  }

  void getDataUser() async {
    String user = await handle_storage.getDataStorage('user');

    setState(() {
      dataUser = jsonDecode(user);
    });
  }

  void getPrevPageData() async {
    dynamic argument = ModalRoute.of(context)!.settings.arguments;

    PesanModel pesan = argument['pesan'];

    controllerNomorSurat.text = pesan.nomor_surat as String;
    controllerNamaSurat.text = pesan.nama as String;
    controllerSatuanKerja.text = pesan.satuan_kerja as String;
    controllerNamaProject.text = pesan.nama_project as String;
    controllerTempat.text = pesan.tempat as String;
    controllerAcara.text = pesan.acara as String;
    controllerFotografer.text = pesan.fotografer as String;
    controllerVideografer.text = pesan.videografer as String;
    controllerLink.text = pesan.link as String;

    String convertWaktuAwal = await convertTime(pesan.waktu_awal.toString());
    String convertWaktuAkhir = await convertTime(pesan.waktu_akhir.toString());

    DateTime waktuAwalDate = DateTime.parse('2000-01-01 $convertWaktuAwal');
    DateTime waktuAkhirDate = DateTime.parse('2000-01-01 $convertWaktuAkhir');

    DateTime tanggalAwalData = DateTime.parse(pesan.tanggal_awal.toString());
    TimeOfDay waktuAwalData = TimeOfDay.fromDateTime(waktuAwalDate);
    DateTime tanggalAkhirData = DateTime.parse(pesan.tanggal_akhir.toString());
    TimeOfDay waktuAkhirData = TimeOfDay.fromDateTime(waktuAkhirDate);

    setState(() {
      pesanId = pesan.id.toString();
      tanggalAwal = tanggalAwalData;
      waktuAwal = waktuAwalData;
      tanggalAkhir = tanggalAkhirData;
      waktuAkhir = waktuAkhirData;
      fileSuratName = pesan.file_surat as String;
    });
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

  Future<void> selectFileSurat() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        fileSuratName = result.names[0].toString();
        fileSurat = result;
      });
    }
  }

  void updateDataPesan(BuildContext context) async {
    var token = await handle_storage.getDataStorage('token');

    var url = Uri.parse("${host.BASE_URL}pesan/update");

    var request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = 'Bearer $token';
    request.headers["Content-Type"] = 'multipart/form-data';

    request.fields['id'] = pesanId;
    request.fields['nomor_surat'] = controllerNomorSurat.text;
    request.fields['satuan_kerja'] = controllerSatuanKerja.text;
    request.fields['nama'] = controllerNamaSurat.text;
    request.fields['nama_project'] = controllerNamaProject.text;

    request.fields['tanggal_awal'] = tanggalAwal.toString().split(' ')[0];
    request.fields['waktu_awal'] =
        "${waktuAwal.hour.toString()}:${waktuAwal.minute.toString()}:00";
    request.fields['tanggal_akhir'] = tanggalAkhir.toString().split(' ')[0];
    request.fields['waktu_akhir'] =
        "${waktuAkhir.hour.toString()}:${waktuAkhir.minute.toString()}:00";

    request.fields['tempat'] = controllerTempat.text;
    request.fields['acara'] = controllerAcara.text;
    request.fields['fotografer'] = controllerFotografer.text.toString();
    request.fields['videografer'] = controllerVideografer.text.toString();
    // status
    request.fields['link'] = controllerLink.text.toString();
    // request.fields['users_id'] = dataUser['id'].toString();

    if (fileSurat != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file_surat',
        fileSurat!.paths[0] as String,
      ));
    }

    final response = await request.send();

    final respBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decodedMap = await json.decode(respBody);

      if (decodedMap['success']) {
        Fluttertoast.showToast(
            msg: "Berhasil mengubah data.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } else if (decodedMap['message'] != null) {
        Fluttertoast.showToast(
            msg: "Gagal mengubah data!, ${decodedMap['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Gagal mengubah data!",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pesan", style: TextStyle(color: Colors.black)),
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
                  padding: EdgeInsets.all(5.0),
                ),
                fileSuratName != ''
                    ? TextButton(
                        onPressed: () {
                          selectFileSurat();
                        },
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, top: 10, right: 14, bottom: 10),
                                child: Text(
                                    "File Surat: ${fileSuratName != '' ? fileSuratName : '-'}"))),
                      )
                    : TextButton(
                        onPressed: () {
                          selectFileSurat();
                        },
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, top: 10, right: 14, bottom: 10),
                                child: Text(
                                    "File Surat: ${fileSurat != null ? fileSurat?.names[0].toString() : '-'}"))),
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
            updateDataPesan(context);
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: colors.primary,
              padding: const EdgeInsets.all(15)),
          child:
              const Text("Edit Pesan", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

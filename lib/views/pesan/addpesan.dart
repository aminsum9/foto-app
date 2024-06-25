import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foto_app/models/project_model.dart';
import 'package:http/http.dart' as http;
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:foto_app/functions/handle_request.dart' as handle_request;

class AddPesan extends StatefulWidget {
  const AddPesan({super.key});
  @override
  AddPesanState createState() => AddPesanState();
}

class AddPesanState extends State<AddPesan> {
  dynamic dataUser;

  FilePickerResult? fileSurat;
  List<ProjectModel> dataProject = [];
  String? selectedProject;

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
  void initState() {
    super.initState();
    getDataUser();
  }

  Future<List<String>> getDataProject(filter) async {
    var body = {"page": "1", "paging": "10"};

    final response = await handle_request.postData(
        Uri.parse("${host.BASE_URL}project"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var ressponseData = await jsonDecode(response.body);

    List<ProjectModel> ressData = [];
    List<String> listProjectsString = [];

    if (ressponseData['success'] == true) {
      for (var i = 0; i < ressponseData['data']['data'].length; i++) {
        dynamic itemProject = ressponseData['data']['data'][i];

        ressData.add(ProjectModel.fromJson(itemProject));
      }

      for (var i = 0; i < ressData.length; i++) {
        ProjectModel itemProject = ressData[i];

        listProjectsString
            .add("${itemProject.nama as String} (${itemProject.id})");
      }

      int dataTotal = ressponseData['data']['total'];

      setState(() {
        dataProject = ressData;
      });

      return listProjectsString;
    } else {
      return listProjectsString;
    }
  }

  void getDataUser() async {
    String user = await handle_storage.getDataStorage('user');

    controllerSatuanKerja.text = jsonDecode(user)['satuan_kerja'].toString();

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
    request.fields['satuan_kerja'] = controllerSatuanKerja.text;
    request.fields['nama'] = controllerNamaSurat.text;
    request.fields['nama_project'] = controllerNamaProject.text;

    // tanggal_awal,
    request.fields['tanggal_awal'] = tanggalAwal.toString().split(' ')[0];
    // waktu_awal,
    request.fields['waktu_awal'] =
        "${waktuAwal.hour.toString()}:${waktuAwal.minute.toString()}:00";
    // tanggal_akhir,
    request.fields['tanggal_akhir'] = tanggalAkhir.toString().split(' ')[0];
    // waktu_akhir,
    request.fields['waktu_akhir'] =
        "${waktuAkhir.hour.toString()}:${waktuAkhir.minute.toString()}:00";

    request.fields['tempat'] = controllerTempat.text;
    request.fields['acara'] = controllerAcara.text;
    request.fields['fotografer'] = controllerFotografer.text.toString();
    request.fields['videografer'] = controllerVideografer.text.toString();
    // --- status
    request.fields['link'] = controllerLink.text.toString();
    request.fields['users_id'] = dataUser['id'].toString();

    if (fileSurat != null) {
      if (fileSurat!.paths.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'file_surat',
          fileSurat!.paths[0] as String,
        ));
      }
    }

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
        // ignore: use_build_context_synchronously
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

  Future<void> selectFileSurat() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        fileSurat = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Pesan Projek", style: TextStyle(color: Colors.black)),
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
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Container(
                  child: DropdownSearch(
                    asyncItems: (filter) => getDataProject(filter),
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Projek",
                        hintText: "pilih projek",
                      ),
                    ),
                    compareFn: (i, s) => i == s,
                    popupProps: PopupPropsMultiSelection.modalBottomSheet(
                      isFilterOnline: true,
                      showSelectedItems: true,
                      showSearchBox: true,
                      selectionWidget: ((context, item, isSelected) =>
                          Text(item as String)),
                      itemBuilder: itemSearch,
                    ),
                    selectedItem: selectedProject,
                    onChanged: (value) => {
                      setState(() {
                        selectedProject = value.toString();
                      })
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
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
                // const Padding(
                //   padding: EdgeInsets.all(10.0),
                // ),
                // TextField(
                //   controller: controllerNamaSurat,
                //   decoration: InputDecoration(
                //       hintText: "masukkan nama surat",
                //       labelText: "Nama Surat",
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(20.0))),
                // ),
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
                TextButton(
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
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
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
              const Text("Pesan Projek", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

Widget itemSearch(
  BuildContext context,
  String item,
  bool isSelected,
) {
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item ?? ''),
      ));
}

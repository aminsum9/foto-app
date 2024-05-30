// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/styles/colors.dart' as colors;

class AddProject extends StatefulWidget {
  const AddProject({super.key});
  @override
  AddProjectState createState() => AddProjectState();
}

class AddProjectState extends State<AddProject> {
  TextEditingController controllerNama = TextEditingController(text: "");
  TextEditingController controllerFotografer = TextEditingController(text: "");
  TextEditingController controllerVideografer = TextEditingController(text: "");

  String? selectedCategory;
  //
  String? imageGambarName = "";

  File imageGambar = File("");

  Future<File> _pickImageGambar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageGambarName = imagePath;
      imageGambar = File(imagePath);
    });
    return File(imagePath);
  }

  Future<String> getDataStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key).toString();
  }

  void addDataProject(BuildContext context) async {
    var token = await getDataStorage('token');

    var url = Uri.parse("${host.BASE_URL}project/add");

    var dataImageGambar = imageGambar;

    var request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = 'Bearer $token';
    request.headers["Content-Type"] = 'multipart/form-data';

    request.fields['nama'] = controllerNama.text;
    request.fields['fotografer'] = controllerFotografer.text.toString();
    request.fields['videografer'] = controllerVideografer.text.toString();

    if (dataImageGambar.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'gambar',
        dataImageGambar.path,
      ));
    }

    final response = await request.send();

    final respBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decodedMap = await json.decode(respBody);

      if (decodedMap['success']) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext contextt) {
            return AlertDialog(
              title: const Text('Berhasil menambah projek baru.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  child:
                      const Text("OK", style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      } else if (decodedMap['message'] != null) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext contextt) {
            return AlertDialog(
              title: const Text('Gagal menambah projek'),
              content: Text(decodedMap['message']),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text("OK", style: TextStyle(color: Colors.green)),
                )
              ],
            );
          },
        );
      }
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contextt) {
          return AlertDialog(
            title: const Text('Gagal menambah projek!'),
            content: const Text("Terjadi kesalahan pada server."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(contextt),
                child: const Text("OK", style: TextStyle(color: Colors.green)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Tambah Projek", style: TextStyle(color: Colors.black)),
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
                  controller: controllerNama,
                  decoration: InputDecoration(
                      hintText: "masukkan nama",
                      labelText: "Nama",
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    imageGambarName != ""
                        ? (SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageGambar,
                              fit: BoxFit.fill,
                            ))))
                        : (const ClipRRect(
                            // borderRadius: BorderRadius.circular(100.0),
                            child: SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: Icon(Icons.widgets,
                                  color: Colors.blueGrey, size: 100.0),
                            ),
                          )),
                    imageGambarName == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageGambar();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageGambarName = "";
                                imageGambar = File("");
                              });
                            },
                            child: const Text("Hapus gambar")))
                  ],
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
            addDataProject(context);
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: colors.primary,
              padding: const EdgeInsets.all(15)),
          child: const Text("TAMBAH Projek",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

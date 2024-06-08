import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foto_app/models/project_model.dart';
import 'package:foto_app/views/home.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

class EditProject extends StatefulWidget {
  const EditProject({super.key});
  @override
  EditProjectState createState() => EditProjectState();
}

class EditProjectState extends State<EditProject> {
  TextEditingController controllerNama = TextEditingController(text: "");
  TextEditingController controllerFotografer = TextEditingController(text: "");
  TextEditingController controllerVideografer = TextEditingController(text: "");

  String projectId = "";
  String? selectedCategory;
  String? imageGambarName = "";
  String? imageNetwork = "";
  File imageGambar = File("");

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      getPrevPageData();
    });
  }

  void getPrevPageData() {
    dynamic argument = ModalRoute.of(context)!.settings.arguments;

    ProjectModel project = argument['project'];

    controllerNama.text = project.nama as String;
    controllerFotografer.text = project.fotografer as String;
    controllerVideografer.text = project.videografer as String;

    setState(() {
      projectId = project.id.toString();
      imageNetwork = project.gambar as String;
    });
  }

  Future<File> _pickImageGambar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageGambarName = imagePath;
      imageNetwork = '';
      imageGambar = File(imagePath);
    });
    return File(imagePath);
  }

  void updateDataProject(BuildContext context) async {
    var token = await handle_storage.getDataStorage('token');

    var url = Uri.parse("${host.BASE_URL}project/update");

    var dataImageGambar = imageGambar;

    var request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = 'Bearer $token';
    request.headers["Content-Type"] = 'multipart/form-data';

    request.fields['id'] = projectId;
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
        Fluttertoast.showToast(
            msg: "Berhasil mengubah data.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
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
        title: const Text("Edit Projek", style: TextStyle(color: Colors.black)),
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
                    // Visibility(
                    //     visible: imageNetwork != "",
                    //     child: ),
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
                        : imageNetwork != ""
                            ? SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                    // borderRadius: BorderRadius.circular(100.0),
                                    child: Image.network(
                                  '${host.BASE_URL_IMG}paket-project/$imageNetwork',
                                  fit: BoxFit.fill,
                                )))
                            : (const ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: SizedBox(
                                  width: 100.0,
                                  height: 100.0,
                                  child: Icon(Icons.widgets,
                                      color: Colors.blueGrey, size: 100.0),
                                ),
                              )),
                    imageGambarName == "" && imageNetwork == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageGambar();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageGambarName = "";
                                imageNetwork = "";
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
            updateDataProject(context);
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: colors.primary,
              padding: const EdgeInsets.all(15)),
          child:
              const Text("Edit Projek", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

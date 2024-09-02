import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});
  @override
  AddCategoryState createState() => AddCategoryState();
}

class AddCategoryState extends State<AddCategory> {
  TextEditingController controllerKategori = TextEditingController(text: "");

  String? selectedCategory;
  //
  String? imageGambarName = "";

  File imageGambar = File("");

  void addDataCategory(BuildContext context) async {
    var token = await handle_storage.getDataStorage('token');

    var url = Uri.parse("${host.BASE_URL}category/add");

    var dataImageGambar = imageGambar;

    var request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = 'Bearer $token';
    request.headers["Content-Type"] = 'multipart/form-data';

    request.fields['kategori'] = controllerKategori.text;

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
            msg: "Berhasil menambah Kategori baru.",
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
      } else if (decodedMap['message'] != null) {
        Fluttertoast.showToast(
            msg: "Gagal menambah Kategori!, ${decodedMap['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Gagal menambah Kategori!",
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
        title: const Text("Tambah Kategori",
            style: TextStyle(color: Colors.black)),
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
                  controller: controllerKategori,
                  decoration: InputDecoration(
                      hintText: "masukkan nama kategori",
                      labelText: "Nama Kategori",
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
            addDataCategory(context);
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: colors.primary,
              padding: const EdgeInsets.all(15)),
          child: const Text("Tambah Kategori",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

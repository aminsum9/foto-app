// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foto_app/models/category_model.dart';
import 'package:foto_app/views/home.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddDocument extends StatefulWidget {
  const AddDocument({super.key});
  @override
  AddDocumentState createState() => AddDocumentState();
}

class AddDocumentState extends State<AddDocument> {
  dynamic dataUser;

  TextEditingController controllerPembuat = TextEditingController(text: "");
  TextEditingController controllerJudul = TextEditingController(text: "");
  TextEditingController controllerLink = TextEditingController(text: "");
  TextEditingController controllerSummary = TextEditingController(text: "");

  List<CategoryModel> listCategories = [];
  String? selectedCategory;
  DateTime documentDate = DateTime.now();
  //
  String? imageFotoName = "";
  String? imageFoto1Name = "";
  String? imageFoto2Name = "";
  String? imageFoto3Name = "";
  String? imageFoto4Name = "";
  String? imageFoto5Name = "";
  String? imageFoto6Name = "";

  File imageFoto = File("");
  File imageFoto1 = File("");
  File imageFoto2 = File("");
  File imageFoto3 = File("");
  File imageFoto4 = File("");
  File imageFoto5 = File("");
  File imageFoto6 = File("");

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

  Future<File> _pickImageFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageFotoName = imagePath;
      imageFoto = File(imagePath);
    });
    return File(imagePath);
  }

  Future<File> _pickImageFoto1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageFoto1Name = imagePath;
      imageFoto1 = File(imagePath);
    });
    return File(imagePath);
  }

  Future<File> _pickImageFoto2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageFoto2Name = imagePath;
      imageFoto2 = File(imagePath);
    });
    return File(imagePath);
  }

  Future<File> _pickImageFoto3() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageFoto3Name = imagePath;
      imageFoto3 = File(imagePath);
    });
    return File(imagePath);
  }

  Future<File> _pickImageFoto4() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageFoto4Name = imagePath;
      imageFoto4 = File(imagePath);
    });
    return File(imagePath);
  }

  Future<File> _pickImageFoto5() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageFoto5Name = imagePath;
      imageFoto5 = File(imagePath);
    });
    return File(imagePath);
  }

  Future<File> _pickImageFoto6() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final imagePath = pickedFile != null ? pickedFile.path : "";

    setState(() {
      imageFoto6Name = imagePath;
      imageFoto6 = File(imagePath);
    });
    return File(imagePath);
  }

  void addDataDocument(BuildContext context) async {
    var token = await handle_storage.getDataStorage('token');

    var url = Uri.parse("${host.BASE_URL}document/add");

    var dataImageFoto = imageFoto;

    var dataImageFoto1 = imageFoto1;
    var dataImageFoto2 = imageFoto2;
    var dataImageFoto3 = imageFoto3;
    var dataImageFoto4 = imageFoto4;
    var dataImageFoto5 = imageFoto5;
    var dataImageFoto6 = imageFoto6;

    String idCategory = "0";

    for (var e in listCategories) {
      if (e.kategori == selectedCategory) {
        idCategory = e.id.toString();
      }
    }

    var request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = 'Bearer $token';
    request.headers["Content-Type"] = 'multipart/form-data';

    request.fields['pembuat'] = dataUser['nama'].toString();
    // request.fields['pembuat'] = controllerPembuat.text;
    request.fields['tanggal'] = documentDate.toString().split('.')[0];
    request.fields['judul'] = controllerJudul.text.toString();
    request.fields['ringkasan'] = controllerSummary.text.toString();
    request.fields['kategori'] = idCategory;
    request.fields['link'] = controllerLink.text.toString();

    if (dataImageFoto.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'foto',
        dataImageFoto.path,
      ));
    }
    if (dataImageFoto1.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'foto1',
        dataImageFoto1.path,
      ));
    }
    if (dataImageFoto2.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'foto2',
        dataImageFoto2.path,
      ));
    }
    if (dataImageFoto3.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'foto3',
        dataImageFoto3.path,
      ));
    }
    if (dataImageFoto4.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'foto4',
        dataImageFoto4.path,
      ));
    }
    if (dataImageFoto5.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'foto5',
        dataImageFoto5.path,
      ));
    }
    if (dataImageFoto6.path != "") {
      request.files.add(await http.MultipartFile.fromPath(
        'foto6',
        dataImageFoto6.path,
      ));
    }

    final response = await request.send();

    final respBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final decodedMap = await json.decode(respBody);

      if (decodedMap['success']) {
        Fluttertoast.showToast(
            msg: "Berhasil menambah dokumen baru.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // (context.findAncestorStateOfType<DocumentState>())?.refreshData();
        // Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else if (decodedMap['message'] != null) {
        Fluttertoast.showToast(
            msg: "Gagal menambah dokumen!, ${decodedMap['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Terjadi kesalahan, Gagal menambah dokumen!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<List<String>> getDataKategori(filter) async {
    var body = {"keyword": filter};

    final response = await handle_request.postData(
        Uri.parse("${host.BASE_URL}category"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    List<CategoryModel> ressData = [];

    if (data['success'] == true) {
      for (var i = 0; i < data['data'].length; i++) {
        dynamic itemCategory = data['data'][i];

        ressData.add(CategoryModel.fromJson(itemCategory));
      }

      setState(() {
        listCategories = ressData;
      });

      List<String> listCategoriesString = [];

      for (var i = 0; i < ressData.length; i++) {
        CategoryModel itemCategory = ressData[i];

        listCategoriesString.add(itemCategory.kategori as String);
      }

      return listCategoriesString;
    } else {
      return [];
    }
  }

  Future<void> selectDocumentDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: documentDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != documentDate) {
      setState(() {
        documentDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Tambah Dokumen", style: TextStyle(color: Colors.black)),
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
                // TextField(
                //   controller: controllerPembuat,
                //   decoration: InputDecoration(
                //       hintText: "masukkan nama pembuat",
                //       labelText: "Pembuat",
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(20.0))),
                // ),
                // const Padding(
                //   padding: EdgeInsets.all(10.0),
                // ),
                TextField(
                  controller: controllerJudul,
                  decoration: InputDecoration(
                      hintText: "masukkan judul",
                      labelText: "Judul",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextField(
                  controller: controllerSummary,
                  decoration: InputDecoration(
                      hintText: "masukkan deskripsi",
                      labelText: "Deskripsi",
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
                DropdownSearch(
                  asyncItems: (filter) => getDataKategori(filter),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Kategori",
                      hintText: "pilih kategori",
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
                  selectedItem: selectedCategory,
                  onChanged: (value) => {
                    setState(() {
                      selectedCategory = value.toString();
                    })
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextButton(
                  onPressed: () {
                    selectDocumentDate();
                  },
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14, top: 10, right: 14, bottom: 10),
                          child: Text(
                              "Tanggal dokumen: ${documentDate.toString().split(' ')[0]}"))),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Foto:'),
                    imageFotoName != ""
                        ? (SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageFoto,
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
                    imageFotoName == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageFoto();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageFotoName = "";
                                imageFoto = File("");
                              });
                            },
                            child: const Text("Hapus gambar")))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Foto 1:'),
                    imageFoto1Name != ""
                        ? (SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageFoto1,
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
                    imageFoto1Name == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageFoto1();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageFoto1Name = "";
                                imageFoto = File("");
                              });
                            },
                            child: const Text("Hapus gambar")))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Foto 2:'),
                    imageFoto2Name != ""
                        ? (SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageFoto2,
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
                    imageFoto2Name == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageFoto2();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageFoto2Name = "";
                                imageFoto2 = File("");
                              });
                            },
                            child: const Text("Hapus gambar")))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Foto 3:'),
                    imageFoto3Name != ""
                        ? (SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageFoto3,
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
                    imageFoto3Name == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageFoto3();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageFoto3Name = "";
                                imageFoto3 = File("");
                              });
                            },
                            child: const Text("Hapus gambar")))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Foto 4:'),
                    imageFoto4Name != ""
                        ? (SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageFoto4,
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
                    imageFoto4Name == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageFoto4();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageFoto4Name = "";
                                imageFoto4 = File("");
                              });
                            },
                            child: const Text("Hapus gambar")))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Foto 5:'),
                    imageFoto5Name != ""
                        ? (SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageFoto5,
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
                    imageFoto5Name == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageFoto5();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageFoto5Name = "";
                                imageFoto5 = File("");
                              });
                            },
                            child: const Text("Hapus gambar")))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Foto 6:'),
                    imageFoto6Name != ""
                        ? (SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                // borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                              imageFoto6,
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
                    imageFoto6Name == ""
                        ? (TextButton(
                            onPressed: () async {
                              _pickImageFoto6();
                            },
                            child: const Text("Pilih gambar")))
                        : (TextButton(
                            onPressed: () async {
                              setState(() {
                                imageFoto6Name = "";
                                imageFoto6 = File("");
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
            addDataDocument(context);
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: colors.primary,
              padding: const EdgeInsets.all(15)),
          child: const Text("Tambah Dokumen",
              style: TextStyle(color: Colors.white)),
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

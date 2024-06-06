import 'package:foto_app/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/views/category.dart';
import 'package:intl/intl.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;

// ignore: must_be_immutable
class DetailCategory extends StatefulWidget {
  CategoryModel category;
  int index;

  DetailCategory({super.key, required this.category, required this.index});

  @override
  DetailCategoryState createState() => DetailCategoryState();
}

class DetailCategoryState extends State<DetailCategory> {
  TextEditingController controllerKategori = TextEditingController(text: "");
  String? categoryId;

  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Kategori?'),
          content: Text(
              "Apakah anda yakin ingin menghapus kategori '${widget.category.kategori}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context, true);
                deleteData(widget.category.id);
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

    getPrevPageData();
  }

  void getPrevPageData() {
    controllerKategori.text = widget.category.kategori as String;

    setState(() {
      categoryId = widget.category.id.toString();
    });
  }

  void updateCategory() async {
    dynamic body = {
      "id": categoryId.toString(),
      "kategori": controllerKategori.text
    };

    var url = "${host.BASE_URL}category/update";

    handle_request.postData(Uri.parse(url), body).then((response) {
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    });
  }

  void deleteData(id) async {
    dynamic body = {"id": id.toString()};

    var url = "${host.BASE_URL}category/delete";

    handle_request.postData(Uri.parse(url), body).then((response) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    String createDate = widget.category.createdAt as String;

    var now = DateTime.now().toString();

    var date = createDate != ''
        ? DateTime.parse(createDate.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAt = DateFormat('dd MMMM yyy').format(date);

    return Scaffold(
        appBar: AppBar(
            title: Text(
              "${widget.category.kategori}",
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: controllerKategori,
                          decoration: InputDecoration(
                              hintText: "masukkan nama kategori",
                              labelText: "Nama Kategori",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => confirmDelete(),
                            child: const Text("HAPUS",
                                style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () => updateCategory(),
                            child: const Text("EDIT",
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ))));
  }
}

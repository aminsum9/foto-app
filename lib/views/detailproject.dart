import 'package:flutter/material.dart';
import 'package:foto_app/models/project_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

// ignore: must_be_immutable
class DetailProject extends StatefulWidget {
  ProjectModel project;
  int index;

  DetailProject({super.key, required this.project, required this.index});

  @override
  DetailProjectState createState() => DetailProjectState();
}

class DetailProjectState extends State<DetailProject> {
  ProjectModel? projectData;
  bool? isUserLogin;

  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Projek?'),
          content: Text(
              "Apakah anda yakin ingin menghapus dokumen '${widget.project.nama}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
              onPressed: () {
                deleteData(widget.project);
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

  void deleteData(ProjectModel project) async {
    dynamic body = {"id": project.id};

    var url = "${host.BASE_URL}project/delete";

    handle_request.postData(Uri.parse(url), body).then((response) {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "${widget.project.nama}",
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
                          widget.project.nama as String,
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
                              Visibility(
                                visible: widget.project.gambar != null &&
                                    widget.project.gambar != '',
                                child: Image.network(
                                  '${host.BASE_URL_IMG}project/${widget.project.gambar}',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              Row(
                                children: [
                                  const Text(
                                    "Nama            : ",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.project.nama}",
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
                                    widget.project.fotografer as String,
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
                                    widget.project.videografer as String,
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
                                  context, '/edit_project',
                                  arguments: {"project": widget.project}),
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

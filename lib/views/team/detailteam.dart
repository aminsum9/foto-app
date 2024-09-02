import 'package:flutter/material.dart';
import 'package:foto_app/models/team_model.dart';
import 'package:intl/intl.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;

// ignore: must_be_immutable
class DetailTeam extends StatefulWidget {
  TeamModel team;
  int index;

  DetailTeam({super.key, required this.team, required this.index});

  @override
  DetailTeamState createState() => DetailTeamState();
}

class DetailTeamState extends State<DetailTeam> {
  TextEditingController controllerFotografer = TextEditingController(text: "");
  TextEditingController controllerVideografer = TextEditingController(text: "");
  String? teamId;

  void confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Team?'),
          content: const Text("Apakah anda yakin ingin menghapus data team?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BATAL", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              child: const Text('HAPUS', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context, true);
                deleteData(widget.team.id);
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
    controllerFotografer.text = widget.team.fotografer as String;
    controllerVideografer.text = widget.team.videografer as String;

    setState(() {
      teamId = widget.team.id.toString();
    });
  }

  void updateTeam() async {
    dynamic body = {
      "id": teamId.toString(),
      "fotografer": controllerFotografer.text,
      "videografer": controllerVideografer.text
    };

    var url = "${host.BASE_URL}team/update";

    handle_request.postData(Uri.parse(url), body).then((response) {
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    });
  }

  void deleteData(id) async {
    dynamic body = {"id": id.toString()};

    var url = "${host.BASE_URL}team/delete";

    handle_request.postData(Uri.parse(url), body).then((response) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    String createDate = widget.team.createdAt as String;

    var now = DateTime.now().toString();

    var date = createDate != ''
        ? DateTime.parse(createDate.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAt = DateFormat('dd MMMM yyy').format(date);

    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Detail Team",
              style: TextStyle(color: Colors.black),
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: controllerFotografer,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "masukkan nama fotografer",
                              labelText: "Jumlah Fotografer",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: controllerVideografer,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "masukkan nama videografer",
                              labelText: "Jumlah Videografer",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Dibuat tanggal: $createdAt'),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => confirmDelete(),
                            child: const Text("HAPUS",
                                style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () => updateTeam(),
                            child: const Text("EDIT",
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                    ]),
              ),
            )));
  }
}

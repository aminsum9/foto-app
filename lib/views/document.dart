import 'dart:async';
import 'dart:convert';
import 'package:foto_app/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:foto_app/views/detaildocument.dart';
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foto_app/functions/host.dart' as host;
// import 'package:foto_app/styles/colors.dart' as colors;

class Document extends StatefulWidget {
  const Document({super.key});

  @override
  DocumentState createState() => DocumentState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class DocumentState extends State<Document> {
  List<DocumentModel> data = [];
  bool? isUserLogin;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<DocumentModel> dataTrans = await getDataDocument();
    String token = await handle_storage.getDataStorage('token');

    setState(() {
      data = dataTrans;
      isUserLogin = token != '';
    });
  }

  Future<List<DocumentModel>> getDataDocument() async {
    var body = {"page": "1", "paging": "10"};

    final response =
        await postData(Uri.parse("${host.BASE_URL}document"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var data = await jsonDecode(response.body);

    List<DocumentModel> ressData = [];

    if (data['success'] == true) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        dynamic itemDocument = data['data']['data'][i];

        ressData.add(DocumentModel.fromJson(itemDocument));
      }

      return ressData;
    } else {
      return ressData;
    }
  }

  Future<void> _handleRefresh() async {
    List<DocumentModel> dataTrans = await getDataDocument();

    setState(() {
      data = dataTrans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: SafeArea(
            child: Scaffold(
                floatingActionButton: isUserLogin == true
                    ? FloatingActionButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/add_document'),
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.add),
                      )
                    : null,
                body: Column(
                  children: [
                    RegularHeader(title: 'Dokumen'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: RefreshIndicator(
                        onRefresh: () => _handleRefresh(),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return ItemDocument(
                                item: data[index],
                                pembuat: data[index].pembuat as String,
                                judul: data[index].judul as String,
                                docCreatedAt: data[index].createdAt as String,
                                index: index);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
                    )
                  ],
                ))));
  }
}

// ignore: must_be_immutable
class ItemDocument extends StatelessWidget {
  String pembuat = '';
  String judul = '';
  String docCreatedAt = '';
  DocumentModel item;
  int index = 0;

  ItemDocument(
      {super.key,
      required this.item,
      required this.pembuat,
      required this.judul,
      required this.docCreatedAt,
      required this.index});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().toString();
    var date = docCreatedAt != ''
        ? DateTime.parse(docCreatedAt.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAt = DateFormat('dd MMMM yyy').format(date);

    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailDocument(document: item, index: index))),
        child: Card(
          child: ListTile(
            title: Row(
              children: [
                Text(
                  judul,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            subtitle: Text('Dibuat tgl. : $createdAt'),
            leading: const Icon(
              Icons.document_scanner_outlined,
              size: 40,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}

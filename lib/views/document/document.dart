import 'dart:async';
import 'dart:convert';
import 'package:foto_app/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:foto_app/views/document/detaildocument.dart';
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:intl/intl.dart';
import 'package:foto_app/functions/host.dart' as host;
// import 'package:foto_app/styles/colors.dart' as colors;

class Document extends StatefulWidget {
  const Document({super.key});

  @override
  DocumentState createState() => DocumentState();
}

class DocumentState extends State<Document> {
  List<DocumentModel> data = [];
  bool? isUserLogin;
  int currentTotalData = 0;
  int page = 1;
  int paging = 10;
  int totalData = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getData();
  }

  void getData() async {
    List<DocumentModel> dataTrans = await getDataDocument(1);
    String token = await handle_storage.getDataStorage('token');

    setState(() {
      data = dataTrans;
      isUserLogin = token != '' && token != "null";
    });
  }

  Future<List<DocumentModel>> getDataDocument(int currentPage) async {
    setState(() {
      page = currentPage;
    });
    var body = {"page": currentPage.toString(), "paging": paging.toString()};

    final response = await handle_request.postData(
        Uri.parse("${host.BASE_URL}document"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var ressponseData = await jsonDecode(response.body);

    List<DocumentModel> ressData = [];

    if (ressponseData['success'] == true) {
      for (var i = 0; i < ressponseData['data']['data'].length; i++) {
        dynamic itemDocument = ressponseData['data']['data'][i];

        ressData.add(DocumentModel.fromJson(itemDocument));
      }

      int dataTotal = ressponseData['data']['total'];

      setState(() {
        data = [...data, ...ressData];
        currentTotalData = currentTotalData + ressData.length;
        totalData = dataTotal;
        loading = false;
      });

      return ressData;
    } else {
      setState(() {
        loading = false;
      });

      return ressData;
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      loading = true;
      page = 1;
      currentTotalData = 0;
      totalData = 0;
    });

    List<DocumentModel> dataTrans = await getDataDocument(1);

    setState(() {
      data = dataTrans;
    });
  }

  // void refreshData() async {
  //   setState(() {
  //     loading = true;
  //     page = 1;
  //     currentTotalData = 0;
  //     totalData = 0;
  //   });

  //   List<DocumentModel> dataTrans = await getDataDocument(1);

  //   setState(() {
  //     data = dataTrans;
  //   });
  // }

  void _loadMoreData() {
    getDataDocument(page + 1);
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
                      child: NotificationListener<ScrollEndNotification>(
                        onNotification: (scrollEnd) {
                          final metrics = scrollEnd.metrics;
                          if (metrics.atEdge) {
                            bool isTop = metrics.pixels == 0;
                            if (isTop) {
                              //
                            } else {
                              if (currentTotalData < totalData) {
                                _loadMoreData();
                              }
                            }
                          }
                          return true;
                        },
                        child: !loading
                            ? data.isEmpty
                                ? const Center(
                                    child: Text('Belum ada data Dokumen!'),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => _handleRefresh(),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return ItemDocument(
                                            item: data[index],
                                            pembuat:
                                                data[index].pembuat as String,
                                            judul: data[index].judul as String,
                                            docCreatedAt:
                                                data[index].createdAt as String,
                                            index: index);
                                      },
                                    ))
                            : const Center(
                                child: CircularProgressIndicator(),
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

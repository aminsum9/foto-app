import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foto_app/models/pesan_model.dart';
import 'package:foto_app/views/pesan/detailpesan.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foto_app/functions/host.dart' as host;

class Pesan extends StatefulWidget {
  const Pesan({super.key});

  @override
  PesanState createState() => PesanState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class PesanState extends State<Pesan> {
  List<PesanModel> data = [];
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
    List<PesanModel> dataTrans = await getDataPesan(1);
    String token = await handle_storage.getDataStorage('token');

    setState(() {
      data = dataTrans;
      isUserLogin = token != '' && token != "null";
    });
  }

  Future<List<PesanModel>> getDataPesan(int currentPage) async {
    var body = {"page": currentPage.toString(), "paging": paging.toString()};

    final response = await postData(Uri.parse("${host.BASE_URL}pesan"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var ressponseData = await jsonDecode(response.body);

    List<PesanModel> ressData = [];

    if (ressponseData['success'] == true) {
      for (var i = 0; i < ressponseData['data']['data'].length; i++) {
        dynamic itemPesan = ressponseData['data']['data'][i];

        ressData.add(PesanModel.fromJson(itemPesan));
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
    List<PesanModel> dataTrans = await getDataPesan(1);

    setState(() {
      data = dataTrans;
    });
  }

  void _loadMoreData() {
    getDataPesan(page + 1);
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
                            Navigator.pushNamed(context, '/add_pesan'),
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.add),
                      )
                    : null,
                body: Column(
                  children: [
                    RegularHeader(title: 'Pesan'),
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
                        child: RefreshIndicator(
                          onRefresh: () => _handleRefresh(),
                          child: !loading
                              ? data.isEmpty
                                  ? const Center(
                                      child: Text('Belum ada data Pesan!'),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return ItemPesan(
                                            item: data[index],
                                            nomor_surat: data[index].nomor_surat
                                                as String,
                                            createdAt:
                                                data[index].createdAt as String,
                                            index: index);
                                      },
                                    )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                    )
                  ],
                ))));
  }
}

// ignore: must_be_immutable
class ItemPesan extends StatelessWidget {
  String nomor_surat = '';
  String createdAt = '';
  PesanModel item;
  int index = 0;

  ItemPesan(
      {super.key,
      required this.item,
      required this.nomor_surat,
      required this.createdAt,
      required this.index});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().toString();
    var date = createdAt != ''
        ? DateTime.parse(createdAt.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String pesanCreatedAt = DateFormat('dd MMMM yyy').format(date);

    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailPesan(pesan: item, index: index))),
        child: Card(
          child: ListTile(
            title: Row(
              children: [
                Text(
                  nomor_surat,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            subtitle: Text('Dibuat tgl. : $pesanCreatedAt'),
            leading: const Icon(
              Icons.build_circle,
              size: 40,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foto_app/models/project_model.dart';
import 'package:foto_app/views/detailproject.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foto_app/functions/host.dart' as host;

class Project extends StatefulWidget {
  const Project({super.key});

  @override
  ProjectState createState() => ProjectState();
}

Future<String> getDataStorage(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key).toString();
}

Future<http.Response> postData(Uri url, dynamic body) async {
  final response = await http.post(url, body: body);
  return response;
}

class ProjectState extends State<Project> {
  List<ProjectModel> data = [];
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
    List<ProjectModel> dataTrans = await getDataProject(1);
    String token = await handle_storage.getDataStorage('token');

    setState(() {
      data = dataTrans;
      isUserLogin = token != '' && token != "null";
    });
  }

  Future<List<ProjectModel>> getDataProject(int currentPage) async {
    var body = {"page": currentPage.toString(), "paging": paging.toString()};

    final response = await postData(Uri.parse("${host.BASE_URL}project"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var ressponseData = await jsonDecode(response.body);

    List<ProjectModel> ressData = [];

    if (ressponseData['success'] == true) {
      for (var i = 0; i < ressponseData['data']['data'].length; i++) {
        dynamic itemProject = ressponseData['data']['data'][i];

        ressData.add(ProjectModel.fromJson(itemProject));
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
    List<ProjectModel> dataTrans = await getDataProject(1);

    setState(() {
      data = dataTrans;
    });
  }

  void _loadMoreData() {
    getDataProject(page + 1);
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
                            Navigator.pushNamed(context, '/add_project'),
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.add),
                      )
                    : null,
                body: Column(
                  children: [
                    RegularHeader(title: 'Projek'),
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
                                      child: Text('Belum ada data Projek!'),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return ItemProject(
                                            item: data[index],
                                            nama: data[index].nama as String,
                                            fotografer: data[index].fotografer
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
class ItemProject extends StatelessWidget {
  String nama = '';
  String fotografer = '';
  String createdAt = '';
  ProjectModel item;
  int index = 0;

  ItemProject(
      {super.key,
      required this.item,
      required this.nama,
      required this.fotografer,
      required this.createdAt,
      required this.index});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().toString();
    var date = createdAt != ''
        ? DateTime.parse(createdAt.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String projectCreatedAt = DateFormat('dd MMMM yyy').format(date);

    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailProject(project: item, index: index))),
        child: Card(
          child: ListTile(
            title: Row(
              children: [
                Text(
                  nama,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            subtitle: Text('Dibuat tgl. : $projectCreatedAt'),
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

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foto_app/models/team_model.dart';
import 'package:foto_app/views/team/detailteam.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:intl/intl.dart';
import 'package:foto_app/functions/host.dart' as host;

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  TeamState createState() => TeamState();
}

class TeamState extends State<Team> {
  List<TeamModel> data = [];
  bool? isUserLogin;
  bool? isAdmin;
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
    List<TeamModel> dataTrans = await getDataTeam(1);
    String token = await handle_storage.getDataStorage('token');
    String roleUsers = await handle_storage.getDataStorage('role_users');

    setState(() {
      data = dataTrans;
      isUserLogin = token != '' && token != "null";
      isAdmin = roleUsers == 'Administrator';
    });
  }

  Future<List<TeamModel>> getDataTeam(int currentPage) async {
    setState(() {
      page = currentPage;
    });
    var body = {"page": currentPage.toString(), "paging": paging.toString()};

    final response =
        await handle_request.postData(Uri.parse("${host.BASE_URL}team"), body);

    if (response.statusCode != 200) {
      return [];
    }

    var ressponseData = await jsonDecode(response.body);

    List<TeamModel> ressData = [];

    if (ressponseData['success'] == true) {
      for (var i = 0; i < ressponseData['data']['data'].length; i++) {
        dynamic itemTeam = ressponseData['data']['data'][i];

        ressData.add(TeamModel.fromJson(itemTeam));
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

    List<TeamModel> dataTrans = await getDataTeam(1);

    setState(() {
      data = dataTrans;
    });
  }

  void _loadMoreData() {
    getDataTeam(page + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Scaffold(
                floatingActionButton: isUserLogin == true && isAdmin == true
                    ? FloatingActionButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/add_team'),
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.add),
                      )
                    : null,
                body: Column(
                  children: [
                    RegularHeader(title: 'Team'),
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
                                    child: Text('Belum ada data Team!'),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => _handleRefresh(),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return ItemTeam(
                                            item: data[index],
                                            fotografer: data[index].fotografer
                                                as String,
                                            videografer: data[index].videografer
                                                as String,
                                            teamCreatedAt:
                                                data[index].createdAt as String,
                                            isUserLogin: isUserLogin,
                                            isAdmin: isAdmin,
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
class ItemTeam extends StatelessWidget {
  String fotografer = '';
  String videografer = '';
  String teamCreatedAt = '';
  TeamModel item;
  int index = 0;
  bool? isUserLogin;
  bool? isAdmin;

  ItemTeam(
      {super.key,
      required this.item,
      required this.fotografer,
      required this.videografer,
      required this.teamCreatedAt,
      required this.isUserLogin,
      required this.isAdmin,
      required this.index});

  Future<String> noResponse() async {
    return '';
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().toString();
    var date = teamCreatedAt != ''
        ? DateTime.parse(teamCreatedAt.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAt = DateFormat('dd MMMM yyy').format(date);

    return SizedBox(
      child: GestureDetector(
        onTap: () => (isUserLogin == true && isAdmin == true)
            ? Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    DetailTeam(team: item, index: index)))
            : noResponse(),
        child: Card(
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jumlah Fotografer: $fotografer",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Jumlah Videografer: $videografer",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            subtitle: Text('Dibuat tgl. : $createdAt'),
            leading: const Icon(
              Icons.group,
              size: 40,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}

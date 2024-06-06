import 'dart:async';
import 'dart:convert';
import 'package:foto_app/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/views/detailcategory.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:intl/intl.dart';
import 'package:foto_app/functions/host.dart' as host;
// import 'package:foto_app/styles/colors.dart' as colors;

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
  List<CategoryModel> data = [];
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
    List<CategoryModel> dataTrans = await getDataCategory(1);
    String token = await handle_storage.getDataStorage('token');

    setState(() {
      data = dataTrans;
      isUserLogin = token != '' && token != "null";
    });
  }

  Future<List<CategoryModel>> getDataCategory(int currentPage) async {
    final response = await handle_request
        .postData(Uri.parse("${host.BASE_URL}category"), {});

    if (response.statusCode != 200) {
      return [];
    }

    var ressponseData = await jsonDecode(response.body);

    List<CategoryModel> ressData = [];

    if (ressponseData['success'] == true) {
      for (var i = 0; i < ressponseData['data'].length; i++) {
        dynamic itemCategory = ressponseData['data'][i];

        ressData.add(CategoryModel.fromJson(itemCategory));
      }

      setState(() {
        data = data;
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

    List<CategoryModel> dataTrans = await getDataCategory(1);

    setState(() {
      data = dataTrans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
            child: Scaffold(
                floatingActionButton: isUserLogin == true
                    ? FloatingActionButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/add_category'),
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.add),
                      )
                    : null,
                body: Column(
                  children: [
                    RegularHeader(title: 'Kategori Dokumen'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: !loading
                          ? data.isEmpty
                              ? const Center(
                                  child: Text('Belum ada data Kategori!'),
                                )
                              : RefreshIndicator(
                                  onRefresh: () => _handleRefresh(),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return ItemCategory(
                                          item: data[index],
                                          kategori:
                                              data[index].kategori as String,
                                          createdAt:
                                              data[index].createdAt as String,
                                          index: index);
                                    },
                                  ))
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    )
                  ],
                ))));
  }
}

// ignore: must_be_immutable
class ItemCategory extends StatelessWidget {
  String kategori = '';
  String createdAt = '';
  CategoryModel item;
  int index = 0;

  ItemCategory(
      {super.key,
      required this.item,
      required this.kategori,
      required this.createdAt,
      required this.index});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().toString();
    var date = createdAt != ''
        ? DateTime.parse(createdAt.split('T')[0])
        : DateTime.parse(now.split('T')[0]);
    String createdAtData = DateFormat('dd MMMM yyy').format(date);

    return SizedBox(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailCategory(category: item, index: index))),
        child: Card(
          child: ListTile(
            title: Row(
              children: [
                Text(
                  kategori,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            subtitle: Text('Dibuat tgl. : $createdAtData'),
            leading: const Icon(
              Icons.category,
              size: 40,
              color: Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}

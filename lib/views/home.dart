import 'package:foto_app/views/account.dart';
import 'package:foto_app/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/views/document.dart';
import 'package:foto_app/views/project.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          Dashboard(),
          Document(),
          Project(),
          Account(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        color: colors.primary,
        child: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.home),
              child: Text(
                "Home",
                style: TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              icon: Icon(Icons.document_scanner_outlined),
              child: Text(
                "Dokumen",
                style: TextStyle(fontSize: 11),
              ),
            ),
            Tab(
              icon: Icon(Icons.build_circle),
              child: Text(
                "Projek",
                style: TextStyle(fontSize: 11),
              ),
            ),
            Tab(
              icon: Icon(Icons.account_circle_rounded),
              child: Text(
                "Akun",
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

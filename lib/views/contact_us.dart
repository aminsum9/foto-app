import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  ContactUsState createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {
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
    String token = await handle_storage.getDataStorage('token');
    String roleUsers = await handle_storage.getDataStorage('role_users');

    setState(() {
      isUserLogin = token != '' && token != "null";
      isAdmin = roleUsers == 'Administrator';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Scaffold(
                body: Column(
      children: [
        RegularHeader(title: 'Hubungi Kami'),
        Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              children: [],
            ))
      ],
    ))));
  }
}

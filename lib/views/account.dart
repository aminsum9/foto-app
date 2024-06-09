import 'dart:convert';

import 'package:foto_app/widgets/button_list.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:foto_app/functions/handle_request.dart' as handle_request;

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {
  dynamic dataUser;
  String userName = '';
  String userEmail = '';
  bool? isUserLogin;
  bool? isAdmin;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    String user = await handle_storage.getDataStorage('user');
    String token = await handle_storage.getDataStorage('token');
    String roleUsers = await handle_storage.getDataStorage('role_users');

    setState(() {
      dataUser = jsonDecode(user);
      userName = dataUser != null ? jsonDecode(user)['nama'] : 'Pengguna';
      userEmail = dataUser != null ? jsonDecode(user)['username'] : "";
      isUserLogin = token != '' && token != "null";
      isAdmin = roleUsers == 'Administrator';
    });
  }

  void handleLogOut() async {
    handle_request.postData(Uri.parse('${host.BASE_URL}user/logout'), {}).then(
        (response) async {
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['success'] == true) {
          await handle_storage.deleteAllStorage();
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/splash');
        } else {
          await handle_storage.deleteAllStorage();
          Navigator.pushNamed(context, '/splash');
        }
      } else {
        await handle_storage.deleteAllStorage();
        Navigator.pushNamed(context, '/splash');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
              child: Container(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: colors.primary,
                  height: 100,
                  child: Row(
                    children: [
                      const Flexible(
                          flex: 1,
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 80,
                          )),
                      Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Visibility(
                                      visible: isUserLogin == true,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 2,
                                            bottom: 2),
                                        margin: const EdgeInsets.only(left: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.blueAccent)),
                                        child: Text(
                                          isAdmin == true ? 'Admin' : 'User',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                ],
                              ),
                              Text(
                                userEmail,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Visibility(
                    visible: isUserLogin == true && isAdmin == true,
                    child: Column(
                      children: [
                        ButtonList(
                            onClick: () =>
                                Navigator.pushNamed(context, '/category'),
                            title: 'Kategori Dokumen'),
                        const Divider()
                      ],
                    )),
                Visibility(
                    visible: isUserLogin == true && isAdmin == true,
                    child: Column(
                      children: [
                        ButtonList(
                            onClick: () =>
                                Navigator.pushNamed(context, '/team'),
                            title: 'Team'),
                        const Divider()
                      ],
                    )),
                Visibility(
                    visible: isUserLogin == true,
                    child: Column(
                      children: [
                        ButtonList(
                            onClick: () =>
                                Navigator.pushNamed(context, '/pesan'),
                            title: 'Pesan'),
                        const Divider()
                      ],
                    )),
                Visibility(
                    visible: isUserLogin == false,
                    child: Column(
                      children: [
                        ButtonList(
                            onClick: () =>
                                Navigator.pushNamed(context, '/login'),
                            title: 'Masuk'),
                      ],
                    )),
                Visibility(
                    visible: isUserLogin == true,
                    child: ButtonList(
                        onClick: () => handleLogOut(), title: 'Keluar'))
              ],
            ),
          )),
        ));
  }
}

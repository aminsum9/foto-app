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

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  void getDataUser() async {
    String user = await handle_storage.getDataStorage('user');

    setState(() {
      dataUser = jsonDecode(user);
      userName = dataUser != null ? jsonDecode(user)['nama'] : 'User';
      userEmail = dataUser != null ? jsonDecode(user)['username'] : "";
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
          //
        }
      } else {
        //
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
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                Visibility(
                    visible: dataUser != null,
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
                    visible: dataUser != null,
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
                    visible: dataUser == null,
                    child: Column(
                      children: [
                        ButtonList(
                            onClick: () =>
                                Navigator.pushNamed(context, '/login'),
                            title: 'Masuk'),
                      ],
                    )),
                Visibility(
                    visible: dataUser != null,
                    child: ButtonList(
                        onClick: () => handleLogOut(), title: 'Keluar'))
              ],
            ),
          )),
        ));
  }
}

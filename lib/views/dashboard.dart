import 'dart:convert';

import 'package:foto_app/widgets/button_regular.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:foto_app/functions/handle_request.dart' as handle_request;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  late dynamic dataUser;
  String userName = '';
  String accountType = '';
  int userBallance = 0;

  @override
  void initState() {
    super.initState();
    getDataUser();
    getBallance();
  }

  void getDataUser() async {
    String user = await handle_storage.getDataStorage('user');

    setState(() {
      dataUser = jsonDecode(user);
      userName =
          jsonDecode(user)?['name'] != null ? jsonDecode(user)['name'] : 'User';
      accountType = jsonDecode(user)['account_type'];
    });
  }

  void getBallance() async {
    var token = await handle_storage.getDataStorage('token');

    if (token.toString() != "") {
      handle_request.postData(
          Uri.parse('${host.BASE_URL}userballance/get-user-ballance'),
          {}).then((response) async {
        if (response.statusCode == 200) {
          if (jsonDecode(response.body)['success'] == true) {
            setState(() {
              userBallance = jsonDecode(response.body)['data'];
            });
          }
        } else {
          //
        }
      });
    } else {
      //
    }
  }

  void upgradeAccountType() async {
    Navigator.pushNamed(context, '/upgrade_premium');
  }

  @override
  Widget build(BuildContext context) {
    Color accTypeColor = Colors.white;
    String accTypeText = '';

    if (accountType == 'reguler') {
      accTypeColor = Colors.green;
      accTypeText = 'Reguler';
    } else if (accountType == 'premium') {
      accTypeColor = Colors.blue;
      accTypeText = 'Premium';
    } else if (accountType == 'silver') {
      accTypeColor = Colors.grey;
      accTypeText = 'Silver';
    } else if (accountType == 'gold') {
      accTypeColor = Colors.orange;
      accTypeText = 'Gold';
    }

    return PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hi, $userName',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              color: accTypeColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            accTypeText,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Visibility(
                            visible: accountType == 'reguler',
                            child: ButtonUpgradeAccType(
                              title: 'upgrade',
                              onClick: () => upgradeAccountType(),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Saldo Rp. $userBallance',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Center(
                        child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(bottom: 20)),
                        Visibility(
                            child: ButtonRegular(
                          title: 'Top Up Saldo',
                          onClick: () =>
                              Navigator.pushNamed(context, '/topup_ballance'),
                        )),
                        const Padding(padding: EdgeInsets.only(bottom: 20)),
                        Visibility(
                            child: ButtonRegular(
                          title: 'Transfer Saldo',
                          onClick: () => Navigator.pushNamed(
                              context, '/transfer_ballance'),
                        ))
                      ],
                    ))
                  ],
                )),
          ),
        ));
  }
}

class ButtonUpgradeAccType extends StatefulWidget {
  @override
  ButtonUpgradeAccTypeState createState() => ButtonUpgradeAccTypeState();
  final String title;
  final Function() onClick;

  @override
  const ButtonUpgradeAccType(
      {super.key, required this.onClick, required this.title});
}

class ButtonUpgradeAccTypeState extends State<ButtonUpgradeAccType> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onClick(),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: Align(
          child: Text(
            widget.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }
}

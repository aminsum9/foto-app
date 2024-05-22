import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:foto_app/functions/handle_request.dart' as handle_request;

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  void checkLogin() async {
    var token = await handle_storage.getDataStorage('token');

    if (token.toString() != "") {
      handle_request
          .postData(Uri.parse('${host.BASE_URL}user/check-login'), {}).then(
              (response) async {
        if (response.statusCode == 200) {
          if (jsonDecode(response.body)['success'] == true) {
            await handle_storage.saveDataStorage('token',
                jsonDecode(response.body)['data']['app_token'].toString());
            await handle_storage.saveDataStorage(
                'user', jsonEncode(jsonDecode(response.body)['data']));

            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, '/home');
          } else {
            Navigator.pushNamed(context, '/home');
          }
        } else {
          Navigator.pushNamed(context, '/home');
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/logo/humas.png",
          width: 180,
          height: 180,
        ),
      ),
    );
  }
}

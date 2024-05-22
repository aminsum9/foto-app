import 'dart:convert';

import 'package:foto_app/widgets/button_regular.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final name = TextEditingController();
  final username = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConf = TextEditingController();

  void handleRegister() async {
    var body = {
      "phone": phone.text,
      "username": email.text,
      "password": password.text,
      "password_conf": passwordConf.text,
    };

    handle_request
        .postData(Uri.parse('${host.BASE_URL}user/register'), body)
        .then((response) async {
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['success'] == true) {
          await handle_storage.saveDataStorage(
              'token', jsonDecode(response.body)['data']['token'].toString());
          await handle_storage.saveDataStorage(
              'user', jsonEncode(jsonDecode(response.body)['data']));

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/home');
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
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RegularHeader(title: "Daftar"),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('No Telepon:'),
                  TextField(
                    controller: phone,
                  ),
                  const Text('Email:'),
                  TextField(
                    controller: email,
                  ),
                  const Text('Password:'),
                  TextField(controller: password, obscureText: true),
                  const Text('Konfirmasi Password:'),
                  TextField(controller: passwordConf, obscureText: true)
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomContainer(
          handleRegister: () => handleRegister(),
        ));
  }
}

class BottomContainer extends StatefulWidget {
  @override
  BottomContainerState createState() => BottomContainerState();
  final Function() handleRegister;

  @override
  const BottomContainer({super.key, required this.handleRegister});
}

class BottomContainerState extends State<BottomContainer> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Container(
      alignment: Alignment.center,
      height: height / 8,
      width: double.infinity,
      child: GestureDetector(
        onTap: () => widget.handleRegister(),
        child: ButtonRegular(
          onClick: () => widget.handleRegister(),
          title: 'Daftar',
        ),
      ),
    );
  }
}

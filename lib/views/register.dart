import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foto_app/widgets/button_regular.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
// import 'package:keyboard_visibility/keyboard_visibility.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final satuanKerja = TextEditingController(text: "BHAYANGKARA");
  final name = TextEditingController();
  final username = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConf = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  String isKeyboardFocus = "false";

  void handleRegister() async {
    var body = {
      "satuan_kerja": satuanKerja.text,
      "nama": name.text,
      "username": email.text,
      "role_users": "User",
      "password": password.text,
      "password_conf": passwordConf.text,
    };

    handle_request
        .postData(Uri.parse('${host.BASE_URL}user/register'), body)
        .then((response) async {
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['success'] == true) {
          await handle_storage.saveDataStorage(
              'token', jsonDecode(response.body)['token'].toString());
          await handle_storage.saveDataStorage(
              'user', jsonEncode(jsonDecode(response.body)['data']));
          await handle_storage.saveDataStorage('role_users',
              jsonDecode(response.body)['data']['role_users'].toString());

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/home');
        } else {
          Fluttertoast.showToast(
              msg: "${jsonDecode(response.body)['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Gagal melakukan registrasi!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          isKeyboardFocus = "true";
        });
      } else {
        Timer(const Duration(seconds: 1), () {
          setState(() {
            isKeyboardFocus = "false";
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        body: SafeArea(
            child: KeyboardListener(
                focusNode: _focusNode,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RegularHeader(title: "Daftar"),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: isKeyboardFocus == "true"
                              ? (height / 2)
                              : (height - 220),
                          child: ListView(
                            children: [
                              Image.asset(
                                "assets/images/logo/humas.png",
                                width: 180,
                                height: 180,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 100)),
                              const Text("Satuan Kerja:"),
                              TextField(
                                  controller: satuanKerja,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ]),
                              const Text("Nama:"),
                              TextField(controller: name),
                              const Text('Email:'),
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                controller: email,
                              ),
                              const Text('Password:'),
                              TextField(
                                  controller: password, obscureText: true),
                              const Text('Konfirmasi Password:'),
                              TextField(
                                  controller: passwordConf, obscureText: true),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 100)),
                            ],
                          ),
                        ))
                  ],
                ))),
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

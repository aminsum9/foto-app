import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foto_app/widgets/regular_header.dart';
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:url_launcher/url_launcher.dart';

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

  openWhatsApp() async {
    var contact = "+6289673526595";
    var androidUrl = "whatsapp://send?phone=$contact&text=";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      Fluttertoast.showToast(
          msg: "Gagal, WhatpApp belum terinstall!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  launchInstagram() async {
    String nativeUrl = "instagram://user?username=PoldaJogja";
    String webUrl = "https://www.instagram.com/PoldaJogja/";
    // ignore: deprecated_member_use
    if (await canLaunchUrl(Uri.parse(nativeUrl))) {
      await launchUrl(Uri.parse(nativeUrl));
    } else if (await launchUrl(Uri.parse(webUrl))) {
      await launchUrl(Uri.parse(webUrl));
    } else {
      Fluttertoast.showToast(
          msg: "Gagal, Tidak bisa membuka Instagram!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  lauchYoutube() async {
    if (Platform.isIOS) {
      if (await canLaunchUrl(
          Uri.parse('youtube://www.youtube.com/@PoldaJogja'))) {
        await launchUrl(Uri.parse('youtube://www.youtube.com/@PoldaJogja'));
      } else {
        if (await canLaunchUrl(
            Uri.parse('https://www.youtube.com/@PoldaJogja'))) {
          await launchUrl(Uri.parse('https://www.youtube.com/@PoldaJogja'));
        } else {
          Fluttertoast.showToast(
              msg: "Gagal, Tidak bisa membuka YouTube!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } else {
      const url = 'https://www.youtube.com/@PoldaJogja';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        Fluttertoast.showToast(
            msg: "Gagal, Tidak bisa membuka YouTube!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 30)),
                GestureDetector(
                  onTap: () => openWhatsApp(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.message_outlined),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Text(
                            '+62-896-7352-6595',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              const ClipboardData(text: '+6289673526595'));
                          Fluttertoast.showToast(
                              msg: "Coppied to clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: const Icon(Icons.copy),
                      )
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.email),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        Text(
                          'manggala.poldadiy@gmail.com',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(
                            text: 'manggala.poldadiy@gmail.com'));
                        Fluttertoast.showToast(
                            msg: "Coppied to clipboard",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      child: const Icon(Icons.copy),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                GestureDetector(
                  onTap: () => launchInstagram(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.photo_camera),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Text(
                            'https://www.instagram.com/PoldaJogja/',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(
                              text: 'https://www.instagram.com/PoldaJogja/'));
                          Fluttertoast.showToast(
                              msg: "Coppied to clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: const Icon(Icons.copy),
                      )
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                GestureDetector(
                  onTap: () => lauchYoutube(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.play_circle_rounded),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Text(
                            'https://www.youtube.com/@PoldaJogja',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(
                              text: 'https://www.youtube.com/@PoldaJogja'));
                          Fluttertoast.showToast(
                              msg: "Coppied to clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: const Icon(Icons.copy),
                      )
                    ],
                  ),
                ),
              ],
            ))
      ],
    ))));
  }
}

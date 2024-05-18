import 'dart:convert';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:foto_app/widgets/button_regular.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/functions/host.dart' as host;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;
import 'package:foto_app/functions/handle_request.dart' as handle_request;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Project extends StatefulWidget {
  const Project({super.key});

  @override
  ProjectState createState() => ProjectState();
}

class ProjectState extends State<Project> {
  late dynamic dataUser;
  String userName = '';
  String accountType = '';
  int userBallance = 0;
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  final List<String> listMissions = [
    'Pelayanan presisi dengan cara memberikan informasi dengan cepat dan tepat serta akurat kepada instansi internal dan eksternal serta masyarakat.',
    'Mengadakan koordinasi dengan pihak terkait antara lain dengan instansi Pemerintah, Perguruan tinggi wilayah Yogyakarta baik negeri maupun swasta, Komisi Informasi DIY, Aliansi Jurnalistik Indonesia (AJI) cabang Yogyakarta, Persatuan Wartawan Indonesia (PWI) cabang Yogyakarta, media massa dan kerjasama dalam pembuatan majalah Tribrata News.',
    'Sebagai cyber public relations posture yang memberikan pelayanan informasi data digital kepada internal Kepolisian dan masyarakat serta memberikan pelayanan dengan cepat dan tepat sehingga tercapai kepercayaan publik dalam manajemen media.'
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'sa3hshEEMuo',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
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

    double screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Image.asset(
                          "assets/images/logo/humas.png",
                          width: 30,
                          height: 30,
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    SizedBox(
                      width: screenWidth,
                      child: CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            initialPage: 0,
                            height: 200.0,
                            enableInfiniteScroll: false,
                          ),
                          items: [
                            Container(
                              width: screenWidth,
                              color: Colors.white,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Image.asset(
                                'assets/images/hero/home.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.blueAccent,
                                topActions: <Widget>[
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      _controller.metadata.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                    onPressed: () {
                                      print('Settings Tapped!');
                                    },
                                  ),
                                ],
                                onReady: () {},
                                onEnded: (data) {},
                              ),
                            ),
                          ]),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Visi'),
                        Padding(padding: EdgeInsets.only(bottom: 20)),
                        Text(
                            'Terwujudnya komunikasi publik bidang Humas yang prediktif, Responsibilitas, transparansi dan berkeadilan yang mantap menuju masyarakat yang aman dan tertib.')
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Misi'),
                        const Padding(padding: EdgeInsets.only(bottom: 20)),
                        BulletedList(
                          listItems: listMissions,
                          listOrder: ListOrder.ordered,
                        ),
                      ],
                    )
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

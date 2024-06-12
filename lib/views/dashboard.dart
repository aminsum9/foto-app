import 'package:bulleted_list/bulleted_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:foto_app/widgets/button_regular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:foto_app/styles/colors.dart' as colors;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

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
  bool? isUserLogin;
  bool? isAdmin;

  late YoutubePlayerController controllerVideo1;
  // late YoutubePlayerController controllerVideo2;
  late TextEditingController idController;
  late TextEditingController seekToController;

  late PlayerState playerState;
  late YoutubeMetaData videoMetaData;
  bool isPlayerReady = false;

  final List<String> listMissions = [
    'Pelayanan presisi dengan cara memberikan informasi dengan cepat dan tepat serta akurat kepada instansi internal dan eksternal serta masyarakat.',
    'Mengadakan koordinasi dengan pihak terkait antara lain dengan instansi Pemerintah, Perguruan tinggi wilayah Yogyakarta baik negeri maupun swasta, Komisi Informasi DIY, Aliansi Jurnalistik Indonesia (AJI) cabang Yogyakarta, Persatuan Wartawan Indonesia (PWI) cabang Yogyakarta, media massa dan kerjasama dalam pembuatan majalah Tribrata News.',
    'Sebagai cyber public relations posture yang memberikan pelayanan informasi data digital kepada internal Kepolisian dan masyarakat serta memberikan pelayanan dengan cepat dan tepat sehingga tercapai kepercayaan publik dalam manajemen media.'
  ];

  @override
  void initState() {
    super.initState();
    controllerVideo1 = YoutubePlayerController(
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

    // controllerVideo2 = YoutubePlayerController(
    //   initialVideoId: 'up68UAfH0d0',
    //   flags: const YoutubePlayerFlags(
    //     mute: false,
    //     autoPlay: false,
    //     disableDragSeek: false,
    //     loop: false,
    //     isLive: false,
    //     forceHD: false,
    //     enableCaption: true,
    //   ),
    // )..addListener(listener);

    idController = TextEditingController();
    seekToController = TextEditingController();
    videoMetaData = const YoutubeMetaData();
    playerState = PlayerState.unknown;

    getStorageData();
  }

  void getStorageData() async {
    String token = await handle_storage.getDataStorage('token');
    String roleUsers = await handle_storage.getDataStorage('role_users');

    setState(() {
      isUserLogin = token != '' && token != "null";
      isAdmin = roleUsers == 'Administrator';
    });
  }

  void listener() {
    if (isPlayerReady && mounted && !controllerVideo1.value.isFullScreen) {
      setState(() {
        playerState = controllerVideo1.value.playerState;
        videoMetaData = controllerVideo1.metadata;
      });
    }
  }

  int currentSlideIdx = 0;

  dynamic onSliderPageChanged(int int, CarouselPageChangedReason) {
    setState(() {
      currentSlideIdx = int;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ListView(
                  children: [
                    const Header(),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    const Divider(
                      height: 1,
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CarouselSlider(
                              options: CarouselOptions(
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                initialPage: 0,
                                height: 200.0,
                                enableInfiniteScroll: false,
                                autoPlay: false,
                                onPageChanged: onSliderPageChanged,
                              ),
                              items: [
                                Container(
                                  width: screenWidth,
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Image.asset(
                                    'assets/images/hero/home.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: screenWidth,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: YoutubePlayer(
                                    controller: controllerVideo1,
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: Colors.blueAccent,
                                    topActions: <Widget>[
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          controllerVideo1.metadata.title,
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
                                        onPressed: () {},
                                      ),
                                    ],
                                    onReady: () {},
                                    onEnded: (data) {},
                                  ),
                                ),
                              ]),
                          const Padding(padding: EdgeInsets.only(bottom: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Dot(isSelected: currentSlideIdx == 0),
                              const Padding(padding: EdgeInsets.only(left: 5)),
                              Dot(isSelected: currentSlideIdx == 1)
                            ],
                          )
                        ],
                      ),
                    ),
                    Visibility(
                        visible: isUserLogin == true && isAdmin != true,
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            Container(
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ButtonRegular(
                                    onClick: () => Navigator.pushNamed(
                                        context, '/add_pesan'),
                                    title: 'Pesan Projek'))
                          ],
                        )),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    VisionAndMission(listMissions: listMissions),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    const WorkFlow(),
                    // const Padding(padding: EdgeInsets.only(bottom: 20)),
                    // Container(
                    //   padding: const EdgeInsets.all(10),
                    //   margin: const EdgeInsets.symmetric(horizontal: 10),
                    //   width: screenWidth,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius:
                    //         const BorderRadius.all(Radius.circular(10)),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.5),
                    //         spreadRadius: 5,
                    //         blurRadius: 7,
                    //         offset: const Offset(
                    //             0, 3), // changes position of shadow
                    //       ),
                    //     ],
                    //   ),
                    //   child: Container(
                    //     width: screenWidth,
                    //     padding: const EdgeInsets.symmetric(horizontal: 20),
                    //     child: YoutubePlayer(
                    //       controller: controllerVideo2,
                    //       showVideoProgressIndicator: true,
                    //       progressIndicatorColor: Colors.blueAccent,
                    //       topActions: <Widget>[
                    //         const SizedBox(width: 8.0),
                    //         Expanded(
                    //           child: Text(
                    //             controllerVideo1.metadata.title,
                    //             style: const TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 18.0,
                    //             ),
                    //             overflow: TextOverflow.ellipsis,
                    //             maxLines: 1,
                    //           ),
                    //         ),
                    //         IconButton(
                    //           icon: const Icon(
                    //             Icons.settings,
                    //             color: Colors.white,
                    //             size: 25.0,
                    //           ),
                    //           onPressed: () {},
                    //         ),
                    //       ],
                    //       onReady: () {},
                    //       onEnded: (data) {},
                    //     ),
                    //   ),
                    // ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    PackageProject(screenWidth: screenWidth),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                )),
          ),
        ));
  }
}

class Header extends StatefulWidget {
  @override
  HeaderState createState() => HeaderState();

  @override
  const Header({super.key});
}

class HeaderState extends State<Header> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bidhumas Polda DIY',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Informasi Dokumentasi Polda\nDaerah Istimewa Yogyakarta.',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 15),
          child: const Text(
            "",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Image.asset(
          "assets/images/logo/humas.png",
          width: 40,
          height: 40,
        )
      ],
    );
  }
}

class WorkFlow extends StatefulWidget {
  @override
  WorkFlowState createState() => WorkFlowState();

  @override
  const WorkFlow({super.key});
}

class WorkFlowState extends State<WorkFlow> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bagaimana Alur Kerja?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
                'Berikut adalah langkah-langkah untuk memesan fotografer dan videografer:'),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icon/message.svg',
                        height: 30,
                        width: 30,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      const Text('1. Pesan')
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icon/bug.svg',
                        height: 30,
                        width: 30,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      const Text('2. Tindakan')
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icon/downlode.svg',
                        height: 30,
                        width: 30,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      const Text('3. Hasil')
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                ],
              ),
            )
          ],
        ));
  }
}

class VisionAndMission extends StatefulWidget {
  @override
  VisionAndMissionState createState() => VisionAndMissionState();
  final List<String> listMissions;

  @override
  const VisionAndMission({super.key, required this.listMissions});
}

class VisionAndMissionState extends State<VisionAndMission> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Visi', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                  'Terwujudnya komunikasi publik bidang Humas yang prediktif, Responsibilitas, transparansi dan berkeadilan yang mantap menuju masyarakat yang aman dan tertib.')
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Misi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 5)),
              BulletedList(
                listItems: widget.listMissions,
                listOrder: ListOrder.ordered,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PackageProject extends StatefulWidget {
  @override
  PackageProjectState createState() => PackageProjectState();
  final double screenWidth;

  @override
  const PackageProject({super.key, required this.screenWidth});
}

class PackageProjectState extends State<PackageProject> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/gallery/DHE08577.jpg',
              fit: BoxFit.cover,
              width: widget.screenWidth,
              height: 200,
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            const Text(
              'Paket Project',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
                'Pilih paket yang sesuai dengan kebutuhan Anda untuk mendapatkan layanan Fotografi dan Videografi yang tepat.'),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            const Text(
                'Dalam menawarkan layanan kami, kami memiliki tiga paket yang dapat Anda pilih, masing-masing dengan jumlah fotografer dan videografer yang berbeda.'),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ));
  }
}

// ignore: must_be_immutable
class Dot extends StatefulWidget {
  @override
  DotState createState() => DotState();
  bool? isSelected;

  @override
  Dot({super.key, this.isSelected});
}

class DotState extends State<Dot> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.isSelected == true ? colors.primary : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}

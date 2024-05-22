import 'package:flutter/material.dart';
import 'package:foto_app/styles/colors.dart' as colors;

// ignore: must_be_immutable
class RegularHeader extends StatefulWidget {
  String title = '';

  @override
  RegularHeaderState createState() => RegularHeaderState();

  @override
  RegularHeader({super.key, required this.title});
}

class RegularHeaderState extends State<RegularHeader> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.white,
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      child: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }
}

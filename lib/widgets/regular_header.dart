import 'package:flutter/material.dart';

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
      height: 60,
      color: Colors.white,
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      child: Center(
        child: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ButtonList extends StatefulWidget {
  @override
  ButtonListState createState() => ButtonListState();
  final String title;
  final Function() onClick;

  @override
  const ButtonList({super.key, required this.onClick, required this.title});
}

class ButtonListState extends State<ButtonList> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      onTap: () => widget.onClick(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: (height / 7) - 50,
        padding: const EdgeInsets.only(left: 5, top: 20, bottom: 20),
        color: Colors.white,
        child: Text(
          widget.title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}

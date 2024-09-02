import 'package:flutter/material.dart';
import 'package:foto_app/styles/colors.dart' as colors;

class ButtonRegular extends StatefulWidget {
  @override
  ButtonRegularState createState() => ButtonRegularState();
  final String title;
  final Function() onClick;

  @override
  const ButtonRegular({super.key, required this.onClick, required this.title});
}

class ButtonRegularState extends State<ButtonRegular> {
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () => widget.onClick(),
      child: Container(
        width: width - 50,
        height: (height / 8) - 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: colors.primary, borderRadius: BorderRadius.circular(10)),
        child: Align(
          child: Text(
            widget.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

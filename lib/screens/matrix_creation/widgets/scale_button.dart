// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class ScaleButton extends StatelessWidget {
  ScaleButton(
      {Key? key,
      required this.text,
      required this.darkTheme,
      required this.func})
      : super(key: key);

  String text;
  bool darkTheme;
  Function func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: blueTheme(darkTheme)),
        child: Text(text),
      ),
    );
  }
}

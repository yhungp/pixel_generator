// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class ScaleButton extends StatelessWidget {
  ScaleButton({
    Key? key,
    required this.text,
    required this.darkTheme,
    required this.func,
    required this.value,
    this.height = 20,
    this.width = 20,
  }) : super(key: key);

  String text;
  bool darkTheme;
  Function func;

  double width = 0;
  double height = 0;
  double value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(value),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: blueTheme(darkTheme)),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

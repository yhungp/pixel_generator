// ignore_for_file: prefer_const_constructors

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class ButtonOnHome extends StatelessWidget {
  ButtonOnHome({
    Key? key,
    required this.label,
    required this.func,
    required this.darkTheme
  }) : super(key: key);

  String label;
  Function func;
  bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(context),
      child: Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: buttonOnHome(darkTheme)
        ),
        child: Text(
          label,
          style: TextStyle(color: buttonOnHomeTextColor(darkTheme)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
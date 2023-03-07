// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  GenericButton({
    Key? key,
    required this.label,
    required this.func,
    required this.darkTheme,
  }) : super(key: key);

  String label;
  Function func;
  bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: buttonOnHome(darkTheme),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

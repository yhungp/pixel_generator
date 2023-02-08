// ignore_for_file: prefer_const_constructors

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

Widget buttonOnMatrix(Function func, bool darkTheme, String text) {
  return GestureDetector(
    onTap: () => func(),
    child: Container(
      width: 150,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: blueTheme(darkTheme)),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

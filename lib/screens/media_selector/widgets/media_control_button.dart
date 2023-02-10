// ignore_for_file: prefer_const_constructors

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

Widget playButtons(
  Function func,
  SettingsScreenNotifier notifier,
  IconData icon,
) {
  return GestureDetector(
    onTap: () => func(),
    child: Container(
      width: 40,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: blueTheme(notifier.darkTheme),
      ),
      child: Icon(
        icon,
        size: 20,
        color: Colors.white,
      ),
    ),
  );
}

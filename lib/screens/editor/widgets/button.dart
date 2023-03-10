// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class EditorButton extends StatelessWidget {
  EditorButton({
    Key? key,
    required this.label,
    required this.func,
    required this.darkTheme,
    this.textOrIcon,
    this.backColor,
    this.withBorders,
  }) : super(key: key);

  String label;
  Function func;
  bool darkTheme;
  Icon? textOrIcon;
  Color? backColor;
  Color? withBorders;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(width: 1, color: withBorders ?? Colors.transparent),
          color: backColor ?? blueTheme(darkTheme),
        ),
        child: textOrIcon ??
            Text(
              label,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}

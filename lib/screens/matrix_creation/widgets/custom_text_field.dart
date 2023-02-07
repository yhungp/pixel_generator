// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
      required this.controller,
      required this.darkTheme,
      required this.index,
      required this.onTextChange,
      required this.upDownValue})
      : super(key: key);

  TextEditingController controller;
  bool darkTheme;

  Function onTextChange;
  Function upDownValue;

  String index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
          margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          width: 150,
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Matrix columns',
              hintStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (value) => onTextChange(),
          ),
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () => upDownValue(true, index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.symmetric(vertical: 2),
                child: Text("⬆"),
              ),
            ),
            GestureDetector(
              onTap: () => upDownValue(false, index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.symmetric(vertical: 2),
                child: Text("⬇"),
              ),
            )
          ],
        )
      ],
    );
  }
}

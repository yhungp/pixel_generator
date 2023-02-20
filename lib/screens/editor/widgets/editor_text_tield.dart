// ignore_for_file: prefer_const_constructors

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SizedBox editorTextField(
  TextEditingController brightnessPin,
  SettingsScreenNotifier notifier,
  Function function,
) {
  return SizedBox(
    width: 60,
    height: 30,
    child: TextField(
      style: TextStyle(color: Colors.white, fontSize: 12),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly
      ],
      cursorColor: Colors.white,
      controller: brightnessPin,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: matrixValuesTextField(notifier.darkTheme)),
        hintStyle: TextStyle(color: matrixValuesTextField(notifier.darkTheme)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: matrixValuesTextField(notifier.darkTheme)), //<-- SEE HERE
        ),
        contentPadding: EdgeInsets.all(0.0),
        // focusColor: Colors.black,
      ),
      onChanged: (value) => function(),
    ),
  );
}

// ignore_for_file: must_be_immutable

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class SetMatrixBlackOrWhite extends StatelessWidget {
  SetMatrixBlackOrWhite({
    Key? key,
    required this.func,
    required this.notifier,
    required this.color,
    required this.textSelector,
  }) : super(key: key);

  Color color;
  Function func;
  SettingsScreenNotifier notifier;
  int textSelector;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: blueTheme(notifier.darkTheme),
        ),
        height: 40,
        child: Text(
          allTo(notifier.language, textSelector),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

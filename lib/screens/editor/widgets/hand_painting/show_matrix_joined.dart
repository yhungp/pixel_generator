// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class ShowMatrixJoined extends StatelessWidget {
  bool showMatrixJoinedFlag;
  Function toogleMatrixJoined;
  SettingsScreenNotifier notifier;

  ShowMatrixJoined({
    Key? key,
    required this.showMatrixJoinedFlag,
    required this.toogleMatrixJoined,
    required this.notifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: blueTheme(notifier.darkTheme),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Text(
            showMatrixLabel(notifier.language),
            style: TextStyle(color: Colors.white),
          ),
          Switch(
            value: showMatrixJoinedFlag,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (value) => toogleMatrixJoined(value),
          ),
        ],
      ),
    );
  }
}

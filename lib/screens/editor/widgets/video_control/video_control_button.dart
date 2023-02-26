// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class VideoControlButton extends StatelessWidget {
  VideoControlButton({
    Key? key,
    required this.func,
    required this.darkTheme,
    required this.icon,
  }) : super(key: key);

  Function func;
  bool darkTheme;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Icon(icon),
      ),
    );
    // return GestureDetector(
    //   onTap: () => func(),
    //   child: Container(
    //     padding: EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.all(Radius.circular(5)),
    //       color: buttonOnHome(darkTheme),
    //     ),
    //     child: Text(
    //       label,
    //       style: TextStyle(color: Colors.white),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    // );
  }
}

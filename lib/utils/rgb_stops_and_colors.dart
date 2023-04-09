import 'package:flutter/material.dart';

var stops = [
  0.07,
  0.23,
  0.40,
  0.50,
  0.65,
  0.80,
  1.0,
];

var colors = [
  const Color.fromARGB(255, 255, 0, 0),
  const Color.fromARGB(255, 255, 255, 0),
  const Color.fromARGB(255, 0, 255, 0),
  const Color.fromARGB(255, 0, 255, 255),
  const Color.fromARGB(255, 0, 0, 255),
  const Color.fromARGB(255, 255, 0, 255),
  const Color.fromARGB(255, 255, 0, 0),
];

List<Color> rapidColors = [
  Colors.black,
  const Color.fromARGB(255, 255, 0, 0),
  const Color.fromARGB(255, 255, 255, 0),
  const Color.fromARGB(255, 0, 255, 0),
  const Color.fromARGB(255, 0, 255, 255),
  const Color.fromARGB(255, 0, 0, 255),
  const Color.fromARGB(255, 255, 0, 255),
  Colors.white,
];

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "").replaceAll("0X", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

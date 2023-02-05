import 'package:flutter/material.dart';

blueTheme(bool darkTheme) {
  return darkTheme ? Colors.blueGrey : Colors.blue;
}

blackTheme(bool darkTheme) {
  return darkTheme ? Colors.black87 : Colors.white;
}

verticalLine() {
  return const Color.fromARGB(255, 150, 150, 150);
}

textColor(bool darkTheme) {
  return darkTheme ? Colors.grey : Colors.black87;
}
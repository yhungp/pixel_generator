import 'package:flutter/material.dart';

blueTheme(bool darkTheme) {
  return darkTheme ? Colors.blueGrey : Colors.blue;
}

blackTheme(bool darkTheme) {
  return darkTheme ? Colors.black87 : Colors.white;
}

dividerLine() {
  return const Color.fromARGB(255, 150, 150, 150);
}

textColor(bool darkTheme) {
  return Colors.grey;
}

buttonOnHomeTextColor(bool darkTheme) {
  return darkTheme ? const Color.fromARGB(255, 200, 200, 200) : Colors.white;
}

buttonOnHome(bool darkTheme) {
  return darkTheme ? Colors.blueGrey : Colors.grey;
}

textColorRecentContainerHome() {
  return Colors.black87;
}

matrixCellColor(bool darkTheme) {
  return darkTheme ? Colors.white : Colors.grey;
}

matrixValuesTextField(bool darkTheme) {
  return darkTheme ? Colors.white : const Color.fromARGB(255, 220, 220, 220);
}

textColorMatrixCreation(bool darkTheme) {
  return darkTheme ? Colors.white : Colors.grey;
}

backToMatrixCreationTheme(bool darkTheme) {
  return darkTheme ? Colors.white : Colors.blue;
}

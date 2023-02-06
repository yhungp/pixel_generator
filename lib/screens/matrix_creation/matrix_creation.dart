// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class MatrixCreation extends StatefulWidget {
  bool darkTheme;
  int language;
  String filePath;

  MatrixCreation({
    Key? key,
    required this.darkTheme,
    required this.language,
    required this.filePath,
  }) : super(key: key);

  @override
  State<MatrixCreation> createState() => _MatrixCreationState();
}

class _MatrixCreationState extends State<MatrixCreation> {
  bool darkTheme = false;
  int language = 0;
  String filePath = "";

  TextEditingController matrixColumns = TextEditingController();
  TextEditingController matrixRows = TextEditingController();
  TextEditingController columns = TextEditingController();
  TextEditingController rows = TextEditingController();

  @override
  void initState() {
    darkTheme = widget.darkTheme;
    language = widget.language;
    filePath = widget.filePath;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: blackTheme(darkTheme),
      child: Column(
        children: [Container()],
      ),
    );
  }
}

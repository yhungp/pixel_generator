// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

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

  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;
  int language = 0;

  String filePath = "";

  TextEditingController matrixColumnsText = TextEditingController();
  TextEditingController matrixRowsText = TextEditingController();
  TextEditingController columnsText = TextEditingController();
  TextEditingController rowsText = TextEditingController();

  @override
  void initState() {
    darkTheme = widget.darkTheme;
    language = widget.language;
    filePath = widget.filePath;

    loadInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: blackTheme(darkTheme),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 120,
                child: TextField(
                  controller: matrixColumnsText,
                ),
              ),
              Container(
                width: 120,
                child: TextField(
                  controller: matrixRowsText,
                ),
              ),
              Container(
                width: 120,
                child: TextField(
                  controller: columnsText,
                ),
              ),
              Container(
                width: 120,
                child: TextField(
                  controller: rowsText,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  loadInfo() async {
    var file = File(filePath);
    if (file.existsSync()) {
      try {
        // Read the file
        final contents = await file.readAsString();

        Map recent = jsonDecode(contents);

        if (recent.containsKey("matrix_columns") &&
            recent["matrix_columns"].runtimeType == int) {
          matrixColumns = recent["matrix_columns"];
          matrixColumnsText.text = recent["matrix_columns"];
        }

        if (recent.containsKey("matrix_rows") &&
            recent["matrix_rows"].runtimeType == int) {
          matrixRows = recent["matrix_rows"];
          matrixRowsText.text = recent["matrix_columns"];
        }

        if (recent.containsKey("matrix_columns") &&
            recent["columns"].runtimeType == int) {
          columns = recent["columns"];
          columnsText.text = recent["matrix_columns"];
        }

        if (recent.containsKey("rows") && recent["rows"].runtimeType == int) {
          rows = recent["rows"];
          rowsText.text = recent["matrix_columns"];
        }

        setState(() {});

        return;
      } catch (e) {
        return;
      }
    }
  }
}

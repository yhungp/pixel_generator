// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:calculator/screens/matrix_creation/widgets/custom_text_field.dart';
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

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  void initState() {
    darkTheme = widget.darkTheme;
    language = widget.language;
    filePath = widget.filePath;

    matrixColumnsText.text = matrixColumns.toString();
    matrixRowsText.text = matrixRows.toString();
    columnsText.text = columns.toString();
    rowsText.text = rows.toString();

    loadInfo();

    super.initState();
  }

  var test = ["TEST", "TEST", "TEST", "TEST", "TEST"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: double.infinity,
      width: double.infinity,
      color: blackTheme(darkTheme),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: blueTheme(darkTheme),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      Text("Individual matrix"),
                      Row(
                        children: [
                          CustomTextField(
                              controller: matrixColumnsText,
                              darkTheme: darkTheme,
                              index: "matrixColumnsText",
                              upDownValue: upDownValue,
                              onTextChange: onTextChange),
                          CustomTextField(
                              controller: matrixRowsText,
                              darkTheme: darkTheme,
                              index: "matrixRowsText",
                              upDownValue: upDownValue,
                              onTextChange: onTextChange),
                        ],
                      ),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: blueTheme(darkTheme),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      Text("Matrix array"),
                      Row(
                        children: [
                          CustomTextField(
                              controller: columnsText,
                              darkTheme: darkTheme,
                              index: "columnsText",
                              upDownValue: upDownValue,
                              onTextChange: onTextChange),
                          CustomTextField(
                              controller: rowsText,
                              darkTheme: darkTheme,
                              index: "rowsText",
                              upDownValue: upDownValue,
                              onTextChange: onTextChange),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              controller: _vertical,
              thumbVisibility: true,
              trackVisibility: true,
              child: Scrollbar(
                controller: _horizontal,
                thumbVisibility: true,
                trackVisibility: true,
                notificationPredicate: (notif) => notif.depth == 1,
                child: SingleChildScrollView(
                  controller: _vertical,
                  child: SingleChildScrollView(
                      controller: _horizontal,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: matrixGenerator(),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  upDownValue(bool upDown, String tag) {
    setState(() {
      switch (tag) {
        case "matrixColumnsText":
          if (upDown) {
            matrixColumnsText.text =
                (int.parse(matrixColumnsText.text) + 1).toString();
            return;
          }
          if (int.parse(matrixColumnsText.text) > 1) {
            matrixColumnsText.text =
                (int.parse(matrixColumnsText.text) - 1).toString();
          }

          break;
        case "matrixRowsText":
          if (upDown) {
            matrixRowsText.text =
                (int.parse(matrixRowsText.text) + 1).toString();
            return;
          }
          if (int.parse(matrixRowsText.text) > 1) {
            matrixRowsText.text =
                (int.parse(matrixRowsText.text) - 1).toString();
          }
          break;
        case "columnsText":
          if (upDown) {
            columnsText.text = (int.parse(columnsText.text) + 1).toString();
            return;
          }
          if (int.parse(columnsText.text) > 1) {
            columnsText.text = (int.parse(columnsText.text) - 1).toString();
          }
          break;
        case "rowsText":
          if (upDown) {
            rowsText.text = (int.parse(rowsText.text) + 1).toString();
            return;
          }
          if (int.parse(rowsText.text) > 1) {
            rowsText.text = (int.parse(rowsText.text) - 1).toString();
          }
          break;
        default:
      }
    });
  }

  matrixGenerator() {
    List<Widget> widgets = List.generate(
        int.parse(rowsText.text),
        (index) => Row(
              children: List.generate(
                  int.parse(columnsText.text),
                  (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          children: List.generate(
                              int.parse(matrixRowsText.text),
                              (index) => Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Row(
                                      children: List.generate(
                                          int.parse(matrixColumnsText.text),
                                          (index) => Container(
                                                width: 10,
                                                height: 10,
                                                color: Colors.white,
                                                margin: EdgeInsets.all(2),
                                              )),
                                    ),
                                  )),
                        ),
                      )),
            ));

    return widgets;
  }

  onTextChange() {
    setState(() {});
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
          setState(() {
            matrixColumns = recent["matrix_columns"];
            matrixColumnsText.text = recent["matrix_columns"].toString();
          });
        }

        if (recent.containsKey("matrix_rows") &&
            recent["matrix_rows"].runtimeType == int) {
          setState(() {
            matrixRows = recent["matrix_rows"];
            matrixRowsText.text = recent["matrix_rows"].toString();
          });
        }

        if (recent.containsKey("matrix_columns") &&
            recent["columns"].runtimeType == int) {
          setState(() {
            columns = recent["columns"];
            columnsText.text = recent["columns"].toString();
          });
        }

        if (recent.containsKey("rows") && recent["rows"].runtimeType == int) {
          setState(() {
            rows = recent["rows"];
            rowsText.text = recent["rows"].toString();
          });
        }

        setState(() {});

        return;
      } catch (e) {
        return;
      }
    }
  }
}

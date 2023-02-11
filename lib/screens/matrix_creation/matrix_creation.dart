// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:calculator/language/matrix_creation.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/matrix_creation/widgets/button.dart';
import 'package:calculator/screens/matrix_creation/widgets/custom_text_field.dart';
import 'package:calculator/screens/matrix_creation/widgets/scale_button.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatrixCreation extends StatefulWidget {
  bool darkTheme;
  int language;
  String filePath;
  Function setRoute;
  Function setProjectFile;

  MatrixCreation({
    Key? key,
    required this.darkTheme,
    required this.language,
    required this.filePath,
    required this.setProjectFile,
    required this.setRoute,
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
  int startingMatrixColumns = 8;
  int startingMatrixRows = 8;
  int startingColumns = 1;
  int startingRows = 1;

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
    return Consumer<SettingsScreenNotifier>(
        builder: (context, notifier, child) {
      return Container(
        padding: EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        color: blackTheme(notifier.darkTheme),
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
                        color: blueTheme(notifier.darkTheme),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      children: [
                        Text(
                          individualMatrix(notifier.language),
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            CustomTextField(
                                controller: matrixColumnsText,
                                darkTheme: notifier.darkTheme,
                                index: "matrixColumnsText",
                                notifier: notifier,
                                upDownValue: upDownValue,
                                onTextChange: onTextChange),
                            CustomTextField(
                                controller: matrixRowsText,
                                darkTheme: notifier.darkTheme,
                                index: "matrixRowsText",
                                notifier: notifier,
                                upDownValue: upDownValue,
                                onTextChange: onTextChange),
                          ],
                        ),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: blueTheme(notifier.darkTheme),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      children: [
                        Text(
                          matrixArray(notifier.language),
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            CustomTextField(
                                controller: columnsText,
                                darkTheme: notifier.darkTheme,
                                index: "columnsText",
                                notifier: notifier,
                                upDownValue: upDownValue,
                                onTextChange: onTextChange),
                            CustomTextField(
                                controller: rowsText,
                                darkTheme: notifier.darkTheme,
                                index: "rowsText",
                                notifier: notifier,
                                upDownValue: upDownValue,
                                onTextChange: onTextChange),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(height: 10),
            arrayOfMatrix(notifier),
            viewScale(notifier)
          ],
        ),
      );
    });
  }

  Expanded arrayOfMatrix(SettingsScreenNotifier notifier) {
    return Expanded(
      child: Scrollbar(
        controller: _vertical,
        thumbVisibility: true,
        trackVisibility: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Scrollbar(
                controller: _horizontal,
                thumbVisibility: true,
                trackVisibility: true,
                notificationPredicate: (notif) => notif.depth == 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _vertical,
                        child: SingleChildScrollView(
                            controller: _horizontal,
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: matrixGenerator(notifier.darkTheme),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double scale = 1;
  Row viewScale(SettingsScreenNotifier notifier) {
    return Row(
      children: [
        ScaleButton(
          text: "-",
          darkTheme: notifier.darkTheme,
          func: downScale,
        ),
        Container(
          width: 100,
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(
            "Zoom: ${scale >= 1 ? scale.toStringAsFixed(0) : scale}",
            style: TextStyle(
              color: textColorMatrixCreation(
                notifier.darkTheme,
              ),
            ),
          ),
        ),
        ScaleButton(
          text: "+",
          darkTheme: notifier.darkTheme,
          func: upScale,
        ),
        Expanded(child: Container()),
        buttonOnMatrix(
          saveAndContinueToNextStep,
          notifier,
          saveAndContinueBtn(notifier.language),
        ),
        // SizedBox(width: 10),
        // buttonOnMatrix(
        //   continueToNextStep,
        //   notifier,
        //   continueBtn(notifier.language),
        // ),
      ],
    );
  }

  checkIsDifferent() {
    return int.parse(matrixColumnsText.text) != startingMatrixColumns ||
        int.parse(matrixRowsText.text) != startingMatrixRows ||
        int.parse(columnsText.text) != startingColumns ||
        int.parse(rowsText.text) != startingRows;
  }

  // continueToNextStep(SettingsScreenNotifier notifier) {
  //   widget.setProjectFile(filePath);
  //   widget.setRoute("media_selector_from_matrix_creation");
  //   notifier.setApplicationScreen(2);
  // }

  saveAndContinueToNextStep(SettingsScreenNotifier notifier) {
    widget.setProjectFile(filePath);
    widget.setRoute("media_selector_from_matrix_creation");
    notifier.setApplicationScreen(2);
  }

  upScale() {
    if (scale >= 1) {
      setState(() {
        scale += 1;
        scale = double.parse(scale.toStringAsFixed(1));
      });
      return;
    }
    if (scale <= 0.9) {
      setState(() {
        scale += 0.1;
        scale = double.parse(scale.toStringAsFixed(1));
      });
      return;
    }
    scale = 1;
  }

  downScale() {
    if (scale > 1) {
      setState(() {
        scale -= 1;
        scale = double.parse(scale.toStringAsFixed(1));
      });
      return;
    }
    if (scale > 0.1) {
      setState(() {
        scale -= 0.1;
        scale = double.parse(scale.toStringAsFixed(1));
      });
      return;
    }
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

  matrixGenerator(bool darkTheme) {
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
                                                width: 10 * scale,
                                                height: 10 * scale,
                                                color:
                                                    matrixCellColor(darkTheme),
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
            startingMatrixColumns = recent["matrix_columns"];
            matrixColumnsText.text = recent["matrix_columns"].toString();
          });
        }

        if (recent.containsKey("matrix_rows") &&
            recent["matrix_rows"].runtimeType == int) {
          setState(() {
            matrixRows = recent["matrix_rows"];
            startingMatrixRows = recent["matrix_rows"];
            matrixRowsText.text = recent["matrix_rows"].toString();
          });
        }

        if (recent.containsKey("matrix_columns") &&
            recent["columns"].runtimeType == int) {
          setState(() {
            columns = recent["columns"];
            startingColumns = recent["columns"];
            columnsText.text = recent["columns"].toString();
          });
        }

        if (recent.containsKey("rows") && recent["rows"].runtimeType == int) {
          setState(() {
            rows = recent["rows"];
            startingRows = recent["rows"];
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

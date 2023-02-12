// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/array_of_matrix.dart';
import 'package:calculator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Editor extends StatefulWidget {
  bool darkTheme;
  int language;
  String filePath;
  Function setRoute;

  Editor({
    Key? key,
    required this.darkTheme,
    required this.language,
    required this.filePath,
    required this.setRoute,
  }) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

enum EditorOptions {
  blackOrWhite,
  greyScale,
  rgbPicker,
  fromImage,
  fromVideo,
}

class _EditorState extends State<Editor> {
  EditorOptions editorOptionsSelected = EditorOptions.blackOrWhite;

  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;
  int startingMatrixColumns = 8;
  int startingMatrixRows = 8;
  int startingColumns = 1;
  int startingRows = 1;

  String filePath = "";

  double scale = 1;

  final ScrollController horizontal = ScrollController();
  final ScrollController vertical = ScrollController();

  @override
  void initState() {
    loadInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsScreenNotifier>(
        builder: (context, notifier, child) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: blackTheme(notifier.darkTheme),
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selector(notifier),
            viewScale(notifier),
            arrayOfMatrix(
              notifier,
              rows,
              columns,
              matrixRows,
              matrixColumns,
              scale,
            ),
          ],
        ),
      );
    });
  }

  Row selector(SettingsScreenNotifier notifier) {
    List<Widget> widgets = [];

    for (var val in EditorOptions.values) {
      var name = val.name;
      name =
          name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

      final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
      var parts = name.split(beforeCapitalLetter);

      if (parts.isNotEmpty && parts[0].isEmpty) parts = parts.sublist(1);

      name = parts.join(" ");
      name = name.toLowerCase();
      name =
          name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

      if (name.startsWith("Rgb")) {
        name = name.replaceFirst("Rgb", "RGB");
      }

      widgets.add(
        SizedBox(
          width: 200,
          child: RadioListTile<EditorOptions>(
            dense: false,
            contentPadding: EdgeInsets.zero,
            title: Text(name),
            value: val,
            activeColor: Colors.white,
            groupValue: editorOptionsSelected,
            onChanged: (EditorOptions? value) {
              setState(() {
                editorOptionsSelected = value!;
              });
            },
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: blueTheme(notifier.darkTheme),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Wrap(children: widgets),
          ),
        )
      ],
    );
  }

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
      ],
    );
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
          });
        }

        if (recent.containsKey("matrix_rows") &&
            recent["matrix_rows"].runtimeType == int) {
          setState(() {
            matrixRows = recent["matrix_rows"];
            startingMatrixRows = recent["matrix_rows"];
          });
        }

        if (recent.containsKey("matrix_columns") &&
            recent["columns"].runtimeType == int) {
          setState(() {
            columns = recent["columns"];
            startingColumns = recent["columns"];
          });
        }

        if (recent.containsKey("rows") && recent["rows"].runtimeType == int) {
          setState(() {
            rows = recent["rows"];
            startingRows = recent["rows"];
          });
        }

        if (recent.containsKey("video") &&
            recent["video"].runtimeType == String) {
          setState(() {
            filePath = recent["video"];
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

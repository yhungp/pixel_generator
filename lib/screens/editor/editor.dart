// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/black_or_white.dart';
import 'package:calculator/screens/editor/gray_scale.dart';
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
          children: [selector(notifier), editorSelector()],
        ),
      );
    });
  }

  editorSelector() {
    switch (editorOptionsSelected) {
      case EditorOptions.blackOrWhite:
        return BlackOrWhite(
          columns: columns,
          matrixColumns: matrixColumns,
          matrixRows: matrixRows,
          rows: rows,
          scale: scale,
        );
      case EditorOptions.greyScale:
        return GreyScale(
          columns: columns,
          matrixColumns: matrixColumns,
          matrixRows: matrixRows,
          rows: rows,
          scale: scale,
        );
      default:
        return Container();
    }
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
            title: Text(
              name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
          });
        }

        if (recent.containsKey("matrix_rows") &&
            recent["matrix_rows"].runtimeType == int) {
          setState(() {
            matrixRows = recent["matrix_rows"];
          });
        }

        if (recent.containsKey("matrix_columns") &&
            recent["columns"].runtimeType == int) {
          setState(() {
            columns = recent["columns"];
          });
        }

        if (recent.containsKey("rows") && recent["rows"].runtimeType == int) {
          setState(() {
            rows = recent["rows"];
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

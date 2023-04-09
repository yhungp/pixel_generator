// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/black_or_white.dart';
import 'package:calculator/screens/editor/from_image.dart';
import 'package:calculator/screens/editor/from_video.dart';
import 'package:calculator/screens/editor/gray_scale.dart';
import 'package:calculator/screens/editor/rgb_picker.dart';
import 'package:calculator/screens/editor/widgets/top_bar/editor_top_bar.dart';
import 'package:calculator/styles/styles.dart';
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
  grayScale,
  rgbPicker,
  fromImage,
  fromVideo,
}

List EditorOptionsLabels = [
  "B/W",
  "Gray",
  "RGB",
  "Image",
  "Video",
];

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

  bool loading = true;

  @override
  void initState() {
    filePath = widget.filePath;
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
          child: loading
              ? Center(
                  child: Text("Loading"),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    EditorTopBar(
                      notifier,
                      setEditorOption,
                      selectorBorderColor,
                      scale,
                      downScale,
                      upScale,
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.grey,
                    ),
                    editorSelector(),
                  ],
                ),
        );
      },
    );
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
      case EditorOptions.grayScale:
        return GreyScale(
          columns: columns,
          matrixColumns: matrixColumns,
          matrixRows: matrixRows,
          rows: rows,
          scale: scale,
        );
      case EditorOptions.rgbPicker:
        return RGB_Picker(
          columns: columns,
          matrixColumns: matrixColumns,
          matrixRows: matrixRows,
          rows: rows,
          scale: scale,
        );
      case EditorOptions.fromImage:
        return From_Image(
          columns: columns,
          matrixColumns: matrixColumns,
          matrixRows: matrixRows,
          rows: rows,
          scale: scale,
          upScale: upScale,
          downScale: downScale,
        );
      case EditorOptions.fromVideo:
        return From_Video(
          columns: columns,
          matrixColumns: matrixColumns,
          matrixRows: matrixRows,
          rows: rows,
          scale: scale,
          upScale: upScale,
          downScale: downScale,
        );
      default:
        return Container();
    }
  }

  setEditorOption(EditorOptions val) {
    setState(() {
      editorOptionsSelected = val;
      scale = 1;
    });
  }

  getMenuItemName(EditorOptions val) {
    var name = val.name;
    name = name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

    final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
    var parts = name.split(beforeCapitalLetter);

    if (parts.isNotEmpty && parts[0].isEmpty) parts = parts.sublist(1);

    name = parts.join(" ");
    name = name.toLowerCase();
    name = name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

    if (name.startsWith("Rgb")) {
      name = name.replaceFirst("Rgb", "RGB");
    }

    return name;
  }

  selectorBorderColor(EditorOptions option, bool darkTheme) {
    return option == editorOptionsSelected ? blackTheme(!darkTheme) : blueTheme(darkTheme);
  }

  upScale(double scaleValue) {
    setState(() {
      scale += scaleValue;
    });
  }

  downScale(double scaleValue) {
    if (scale - scaleValue > 0) {
      setState(() {
        scale -= scaleValue;
      });
    }
  }

  loadInfo() async {
    var file = File(filePath);
    if (file.existsSync()) {
      try {
        // Read the file
        final contents = await file.readAsString();

        Map recent = jsonDecode(contents);

        if (recent.containsKey("matrix_columns") && recent["matrix_columns"].runtimeType == int) {
          setState(() {
            matrixColumns = recent["matrix_columns"];
          });
        }

        if (recent.containsKey("matrix_rows") && recent["matrix_rows"].runtimeType == int) {
          setState(() {
            matrixRows = recent["matrix_rows"];
          });
        }

        if (recent.containsKey("matrix_columns") && recent["columns"].runtimeType == int) {
          setState(() {
            columns = recent["columns"];
          });
        }

        if (recent.containsKey("rows") && recent["rows"].runtimeType == int) {
          setState(() {
            rows = recent["rows"];
          });
        }

        if (recent.containsKey("video") && recent["video"].runtimeType == String) {
          setState(() {
            filePath = recent["video"];
          });
        }

        setState(() {
          loading = false;
        });

        return;
      } catch (e) {
        setState(() {
          loading = false;
        });
        return;
      }
    }

    setState(() {
      loading = false;
    });
  }
}

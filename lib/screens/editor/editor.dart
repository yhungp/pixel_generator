// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/black_or_white.dart';
import 'package:calculator/screens/editor/from_image.dart';
import 'package:calculator/screens/editor/from_video.dart';
import 'package:calculator/screens/editor/gray_scale.dart';
import 'package:calculator/screens/editor/rgb_picker.dart';
import 'package:calculator/screens/editor/widgets/scale_button.dart';
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
                    Row(
                      children: [selector(notifier), SizedBox(width: 10), viewScale(notifier)],
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
      case EditorOptions.greyScale:
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
        );
      case EditorOptions.fromVideo:
        return From_Video(
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

  Row selector(SettingsScreenNotifier notifier) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: blueTheme(notifier.darkTheme),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          margin: EdgeInsets.all(5),
          child: DropdownButton<EditorOptions>(
            value: editorOptionsSelected,
            dropdownColor: blueTheme(notifier.darkTheme),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white, // <-- SEE HERE
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            onChanged: (newValue) {
              setState(() {
                editorOptionsSelected = newValue!;
              });
            },
            items: EditorOptions.values.map((EditorOptions option) {
              return DropdownMenuItem<EditorOptions>(
                value: option,
                child: Text(
                  getMenuItemName(option),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  // option.name.toString(),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );

    // List<Widget> widgets = [];

    // for (var val in EditorOptions.values) {
    //   var name = val.name;
    //   name = name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

    //   final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
    //   var parts = name.split(beforeCapitalLetter);

    //   if (parts.isNotEmpty && parts[0].isEmpty) parts = parts.sublist(1);

    //   name = parts.join(" ");
    //   name = name.toLowerCase();
    //   name = name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

    //   if (name.startsWith("Rgb")) {
    //     name = name.replaceFirst("Rgb", "RGB");
    //   }

    //   widgets.add(
    //     SizedBox(
    //       width: 150,
    //       child: RadioListTile<EditorOptions>(
    //         visualDensity: const VisualDensity(
    //           horizontal: VisualDensity.minimumDensity,
    //           vertical: VisualDensity.minimumDensity,
    //         ),
    //         dense: false,
    //         contentPadding: EdgeInsets.zero,
    //         title: Text(
    //           name,
    //           style: TextStyle(
    //             color: Colors.white,
    //           ),
    //         ),
    //         value: val,
    //         activeColor: Colors.white,
    //         groupValue: editorOptionsSelected,
    //         onChanged: (EditorOptions? value) {
    //           setState(() {
    //             editorOptionsSelected = value!;
    //           });
    //         },
    //       ),
    //     ),
    //   );
    // }

    // return Row(
    //   children: [
    //     Expanded(
    //       child: Container(
    //         padding: EdgeInsets.all(5),
    //         margin: EdgeInsets.all(5),
    //         decoration: BoxDecoration(
    //           color: blueTheme(notifier.darkTheme),
    //           borderRadius: BorderRadius.all(
    //             Radius.circular(5),
    //           ),
    //         ),
    //         child: Wrap(children: widgets),
    //       ),
    //     )
    //   ],
    // );
  }

  Row viewScale(SettingsScreenNotifier notifier) {
    return Row(
      children: [
        for (double value in [1, 0.1, 0.01])
          Row(
            children: [
              ScaleButton(
                text: "- $value",
                darkTheme: notifier.darkTheme,
                func: downScale,
                width: 50,
                value: value,
              ),
              SizedBox(width: 5),
            ],
          ),
        Container(
          width: 100,
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(
            "Zoom: ${scale.toStringAsFixed(2)}",
            style: TextStyle(
              color: textColorMatrixCreation(
                notifier.darkTheme,
              ),
            ),
          ),
        ),
        for (double value in [0.01, 0.1, 1])
          Row(
            children: [
              ScaleButton(
                text: "+ $value",
                darkTheme: notifier.darkTheme,
                func: upScale,
                width: 50,
                value: value,
              ),
              SizedBox(width: 5),
            ],
          ),
      ],
    );
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

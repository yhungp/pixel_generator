// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/black_or_white.dart';
import 'package:calculator/screens/editor/from_image.dart';
import 'package:calculator/screens/editor/from_video.dart';
import 'package:calculator/screens/editor/gray_scale.dart';
import 'package:calculator/screens/editor/rgb_picker.dart';
import 'package:calculator/screens/editor/widgets/top_bar/editor_top_bar.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/utils/pretty_json.dart';
import 'package:calculator/utils/rgb_stops_and_colors.dart';
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

List editorOptionsLabels = [
  "B/W",
  "Gray",
  "RGB",
  "Image",
  "Video",
];

class _EditorState extends State<Editor> {
  EditorOptions editorOptionsSelected = EditorOptions.blackOrWhite;
  EditorOptions loadedEditorOptionsSelected = EditorOptions.blackOrWhite;

  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;

  String filePath = "";

  double scale = 1;

  final ScrollController horizontal = ScrollController();
  final ScrollController vertical = ScrollController();

  bool loading = true;
  bool executeSave = false;

  @override
  void initState() {
    filePath = widget.filePath;
    loadInfo();

    super.initState();
  }

  List<List<List<List<Color>>>> colors = [];

  setColors(List<List<List<List<Color>>>> c, int language) async {
    List<List<List<List<String>>>> colorLabels = [];

    colorLabels = List.generate(
      rows,
      (i) => List.generate(
        columns,
        (j) => List.generate(
          matrixRows,
          (x) => List.generate(
            matrixColumns,
            (y) => colToString(c[i][j][x][y]),
          ),
        ),
      ),
    );

    var file = File(filePath);

    if (!file.existsSync()) {
      file.createSync();
    }

    final contents = await file.readAsString();
    Map data = jsonDecode(contents);

    data["colors"] = colorLabels;
    data["type"] = editorOptionsSelected == EditorOptions.blackOrWhite
        ? "bw"
        : editorOptionsSelected == EditorOptions.grayScale
            ? "gray"
            : "rgb";

    colors = getColors(colorLabels);
    loadedEditorOptionsSelected = editorOptionsSelected;

    file.writeAsString(prettyJson(data));

    executeSave = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(fileSavedLabel(language)),
          content: Text(fileSavedSuccessfullyLabel(language)),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  colToString(Color c) {
    String txt = c.toString();
    txt = txt.replaceAll("Color(", "").replaceAll(")", "");
    return txt;
  }

  saveColors(bool value) {
    setState(() {
      executeSave = value;
    });
  }

  getSaveState() {
    return executeSave;
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
                      saveColors,
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
          getSaveState: getSaveState,
          setColors: setColors,
          colors: loadedEditorOptionsSelected == editorOptionsSelected ? colors : getGenericColorList(),
        );
      case EditorOptions.grayScale:
        return GreyScale(
          columns: columns,
          matrixColumns: matrixColumns,
          matrixRows: matrixRows,
          rows: rows,
          scale: scale,
          getSaveState: getSaveState,
          setColors: setColors,
          colors: loadedEditorOptionsSelected == editorOptionsSelected ? colors : getGenericColorList(),
        );
      case EditorOptions.rgbPicker:
        return RGB_Picker(
          columns: columns,
          matrixColumns: matrixColumns,
          matrixRows: matrixRows,
          rows: rows,
          scale: scale,
          getSaveState: getSaveState,
          setColors: setColors,
          colors: loadedEditorOptionsSelected == editorOptionsSelected ? colors : getGenericColorList(),
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
          matrixColumns = recent["matrix_columns"];
        }

        if (recent.containsKey("matrix_rows") && recent["matrix_rows"].runtimeType == int) {
          matrixRows = recent["matrix_rows"];
        }

        if (recent.containsKey("matrix_columns") && recent["columns"].runtimeType == int) {
          columns = recent["columns"];
        }

        if (recent.containsKey("rows") && recent["rows"].runtimeType == int) {
          rows = recent["rows"];
        }

        if (recent.containsKey("video") && recent["video"].runtimeType == String) {
          filePath = recent["video"];
        }

        if (recent.containsKey("type") && ["bw", "gray", "rgb"].contains(recent["type"].toString().toLowerCase())) {
          switch (recent["type"]) {
            case "bw":
              editorOptionsSelected = EditorOptions.blackOrWhite;
              break;
            case "gray":
              editorOptionsSelected = EditorOptions.grayScale;
              break;
            case "rgb":
              editorOptionsSelected = EditorOptions.rgbPicker;
              break;
          }

          loadedEditorOptionsSelected = editorOptionsSelected;
          colors = recent.containsKey("colors") ? getColors(recent["colors"]) : getGenericColorList();
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

  List<List<List<List<Color>>>> getColors(List c) {
    if (c.length != rows) {
      return getGenericColorList();
    }

    for (var elementRow in c) {
      if (elementRow.length != columns) {
        return getGenericColorList();
      }

      for (var elementColumn in elementRow) {
        if (elementColumn.length != matrixRows) {
          return getGenericColorList();
        }

        for (var elementMatrixRow in elementColumn) {
          if (elementMatrixRow.length != matrixRows) {
            return getGenericColorList();
          }

          for (var elementMatrixColumn in elementMatrixRow) {
            try {
              HexColor(elementMatrixColumn);
            } catch (_) {
              return getGenericColorList();
            }
          }
        }
      }
    }

    return List.generate(
      rows,
      (i) => List.generate(
        columns,
        (j) => List.generate(
          matrixRows,
          (x) => List.generate(
            matrixColumns,
            (y) => checkColor(HexColor(c[i][j][x][y])),
          ),
        ),
      ),
    );
  }

  checkColor(Color c) {
    if (editorOptionsSelected == EditorOptions.rgbPicker) {
      return c;
    }

    if (editorOptionsSelected == EditorOptions.blackOrWhite) {
      if (c.red < 100 && c.green < 100 && c.blue < 100) {
        return Colors.black;
      }
      return Colors.white;
    }

    int gray = (c.red + c.green + c.blue) ~/ 3;

    return Color.fromARGB(c.alpha, gray, gray, gray);
  }

  getGenericColorList() {
    return List.generate(
      rows,
      (i) => List.generate(
        columns,
        (j) => List.generate(
          matrixRows,
          (x) => List.generate(
            matrixColumns,
            (y) => Colors.white,
          ),
        ),
      ),
    );
  }
}

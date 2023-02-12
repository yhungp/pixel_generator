// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/array_of_matrix.dart';
import 'package:calculator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlackOrWhite extends StatefulWidget {
  int matrixColumns;
  int matrixRows;
  int columns;
  int rows;
  double scale;

  BlackOrWhite({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.scale,
  }) : super(key: key);

  @override
  State<BlackOrWhite> createState() => _BlackOrWhiteState();
}

enum ColorOptions {
  black,
  white,
}

class _BlackOrWhiteState extends State<BlackOrWhite> {
  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;
  double scale = 1;

  List<List<List<List<Color>>>> colors = [];

  ColorOptions colorOptions = ColorOptions.black;

  @override
  void initState() {
    scale = widget.scale;
    matrixColumns = widget.matrixColumns;
    matrixRows = widget.matrixRows;
    columns = widget.columns;
    rows = widget.rows;

    colors = List.generate(
      rows,
      (index) => List.generate(
        columns,
        (index) => List.generate(
          matrixRows,
          (index) => List.generate(
            matrixColumns,
            (index) => Colors.white,
          ),
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsScreenNotifier>(
        builder: (context, notifier, child) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: viewScale(notifier),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          colors = List.generate(
                            rows,
                            (index) => List.generate(
                              columns,
                              (index) => List.generate(
                                matrixRows,
                                (index) => List.generate(
                                  matrixColumns,
                                  (index) => Colors.black,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: blueTheme(notifier.darkTheme),
                        ),
                        height: 40,
                        child: Text(
                          allTo(notifier.language, 0),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          colors = List.generate(
                            rows,
                            (index) => List.generate(
                              columns,
                              (index) => List.generate(
                                matrixRows,
                                (index) => List.generate(
                                  matrixColumns,
                                  (index) => Colors.white,
                                ),
                              ),
                            ),
                          );
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: blueTheme(notifier.darkTheme),
                        ),
                        height: 40,
                        child: Text(
                          allTo(notifier.language, 1),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: blueTheme(notifier.darkTheme),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      arrayOfMatrix(
                        notifier,
                        rows,
                        columns,
                        matrixRows,
                        matrixColumns,
                        scale,
                        onClick: editPixel,
                        colors: colors,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      "Color:   ",
                      style: TextStyle(
                        fontSize: 20,
                        color: textColorBlackOrWhite(
                          notifier.darkTheme,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: selector(
                        notifier,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Row selector(SettingsScreenNotifier notifier) {
    List<Widget> widgets = [];

    for (var val in ColorOptions.values) {
      var name = val.name;
      name =
          name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

      widgets.add(
        SizedBox(
          width: 100,
          child: RadioListTile<ColorOptions>(
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
            groupValue: colorOptions,
            onChanged: (ColorOptions? value) {
              setState(() {
                colorOptions = value!;
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
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: widgets,
            ),
          ),
        )
      ],
    );
  }

  allToWhite() {}

  editPixel(
    int rowsCountIndex,
    int columnsCountIndex,
    int matrixRowsTextCountIndex,
    int matrixColumnsTextCountIndex,
  ) {
    if (colorOptions == ColorOptions.black) {
      setState(() {
        colors[rowsCountIndex][columnsCountIndex][matrixRowsTextCountIndex]
            [matrixColumnsTextCountIndex] = Colors.black;
      });
      return;
    }
    setState(() {
      colors[rowsCountIndex][columnsCountIndex][matrixRowsTextCountIndex]
          [matrixColumnsTextCountIndex] = Colors.white;
    });
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
}

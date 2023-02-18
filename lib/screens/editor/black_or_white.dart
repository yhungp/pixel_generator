// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/styles/styles.dart';
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

class _BlackOrWhiteState extends State<BlackOrWhite> {
  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;
  double scale = 1;

  double posx = 0;
  double posy = 0;

  double posxColorBar = 0;
  double posyColorBar = 0;

  double posxMatrixPainter = 0;
  double posyMatrixPainter = 0;

  Color currentColor = Colors.white;

  List<List<List<List<Color>>>> colors = [];

  bool peekingColor = false;
  bool grayScaleTouched = false;
  bool rgbScaleTouched = false;
  bool matrixTouched = false;

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

  checkIfCoordinatesOnRectangle(double posx, double posy) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        for (int x = 0; x < matrixRows; x++) {
          for (int y = 0; y < matrixColumns; y++) {
            double dx =
                (j + x) * 13 * scale + 13.0 * scale * j * matrixColumns - 5 * j;
            double dy =
                (i + y) * 13 * scale + 13.0 * scale * i * matrixRows - 5 * i;

            bool pixelTouched = posx > dx &&
                posx < dx + 10 * scale &&
                posy > dy &&
                posy < dy + 10 * scale;

            if (pixelTouched) {
              editPixel(i, j, x, y);
            }
          }
        }
      }
    }
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
                    SizedBox(
                      width: 10,
                    ),
                    selector(
                      notifier,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: blueTheme(notifier.darkTheme),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onPanUpdate: (details) {
                                final tapPosition = details.localPosition;

                                setState(() {
                                  posxMatrixPainter = tapPosition.dx;
                                  posyMatrixPainter = tapPosition.dy;

                                  checkIfCoordinatesOnRectangle(
                                    posxMatrixPainter,
                                    posyMatrixPainter,
                                  );

                                  matrixTouched = true;
                                });
                              },
                              onTapDown: (TapDownDetails details) {
                                final tapPosition = details.localPosition;

                                setState(() {
                                  posxMatrixPainter = tapPosition.dx;
                                  posyMatrixPainter = tapPosition.dy;

                                  checkIfCoordinatesOnRectangle(
                                    posxMatrixPainter,
                                    posyMatrixPainter,
                                  );

                                  matrixTouched = true;
                                });
                              },
                              onPanEnd: (_) {
                                setState(() {
                                  matrixTouched = false;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  matrixTouched = false;
                                });
                              },
                              child: CustomPaint(
                                size: Size(
                                  matrixColumns * 13.0 * columns +
                                      (columns - 1) * 5,
                                  matrixRows * 13.0 * rows + (rows - 1) * 5,
                                ),
                                painter: MatrixPainter(
                                  posxMatrixPainter,
                                  posyMatrixPainter,
                                  false,
                                  columns,
                                  matrixColumns,
                                  matrixRows,
                                  rows,
                                  matrixTouched,
                                  currentColor,
                                  colors,
                                  scale,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Row selector(SettingsScreenNotifier notifier) {
    List<Widget> widgets = [];

    for (var val in ["black", "white"]) {
      var name = val;
      name =
          name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

      final Color color = val == "black" ? Colors.black : Colors.white;

      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              currentColor = color;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: color == currentColor ? Colors.grey : Colors.transparent,
                width: 3,
              ),
            ),
            width: 25,
            height: 25,
            margin: EdgeInsets.only(right: val == "black" ? 10 : 0),
          ),
        ),
      );
    }

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: 40,
          padding: EdgeInsets.all(5),
          // margin: EdgeInsets.only(left: 8),
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
    setState(() {
      colors[rowsCountIndex][columnsCountIndex][matrixRowsTextCountIndex]
          [matrixColumnsTextCountIndex] = currentColor;
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

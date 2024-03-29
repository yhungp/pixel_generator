// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/button.dart';
import 'package:calculator/screens/editor/widgets/hand_painting/code_from_colors_widget.dart';
import 'package:calculator/screens/editor/widgets/hand_painting/set_matrix_black_or_white.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/screens/editor/widgets/hand_painting/show_matrix_joined.dart';
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
  Function setColors;
  Function getSaveState;
  List<List<List<List<Color>>>> colors;

  BlackOrWhite({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.scale,
    required this.getSaveState,
    required this.setColors,
    required this.colors,
  }) : super(key: key);

  @override
  State<BlackOrWhite> createState() => _BlackOrWhiteState();
}

class _BlackOrWhiteState extends State<BlackOrWhite> {
  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;
  int language = 0;

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
  bool showMatrixJoinedFlag = false;
  bool showCode = false;

  @override
  void initState() {
    scale = widget.scale;
    matrixColumns = widget.matrixColumns;
    matrixRows = widget.matrixRows;
    columns = widget.columns;
    rows = widget.rows;
    colors = widget.colors;

    super.initState();
  }

  checkIfCoordinatesOnRectangle(double posx, double posy) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        for (int x = 0; x < matrixRows; x++) {
          for (int y = 0; y < matrixColumns; y++) {
            double dx = (j + x) * 13 * scale + 13.0 * scale * j * matrixColumns - (showMatrixJoinedFlag ? 13 : 5) * j;
            double dy = (i + y) * 13 * scale + 13.0 * scale * i * matrixRows - (showMatrixJoinedFlag ? 13 : 5) * i;

            bool pixelTouched = posx > dx && posx < dx + 10 * scale && posy > dy && posy < dy + 10 * scale;

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
    if (widget.getSaveState()) {
      widget.setColors(colors, language);
      setState(() {});
    }

    return Consumer<SettingsScreenNotifier>(builder: (context, notifier, child) {
      language = notifier.language;

      return Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SetMatrixBlackOrWhite(
                      func: () => setColors(Colors.black),
                      notifier: notifier,
                      color: Colors.white,
                      textSelector: 0,
                    ),
                    SizedBox(width: 10),
                    SetMatrixBlackOrWhite(
                      func: () => setColors(Colors.white),
                      notifier: notifier,
                      color: Colors.white,
                      textSelector: 1,
                    ),
                    SizedBox(width: 10),
                    selector(notifier),
                    SizedBox(width: 10),
                    Expanded(child: Container()),
                    ShowMatrixJoined(
                      showMatrixJoinedFlag: showMatrixJoinedFlag,
                      toogleMatrixJoined: toogleMatrixJoined,
                      notifier: notifier,
                    ),
                    SizedBox(width: 10),
                    EditorButton(
                      label: !showCode ? generateCode(notifier.language) : hideCode(notifier.language),
                      func: () {
                        setState(() {
                          showCode = !showCode;
                        });
                      },
                      darkTheme: notifier.darkTheme,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    showCode
                        ? CodeFromColorsWidget(
                            colors: colors,
                            notifier: notifier,
                            showHideCode: showHideCode,
                          )
                        : Expanded(
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
                                  MouseRegion(
                                    cursor: peekingColor ? SystemMouseCursors.click : SystemMouseCursors.basic,
                                    child: GestureDetector(
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
                                          matrixColumns * 13.0 * columns + (columns - 1) * 5,
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
                                          widget.scale,
                                          dontShowSpaceBetweenMatrix: showMatrixJoinedFlag,
                                        ),
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

  showHideCode(bool value) {
    setState(() {
      showCode = value;
    });
  }

  setColors(Color color) {
    setState(() {
      colors = List.generate(
        rows,
        (index) => List.generate(
          columns,
          (index) => List.generate(
            matrixRows,
            (index) => List.generate(
              matrixColumns,
              (index) => color,
            ),
          ),
        ),
      );
    });
  }

  toogleMatrixJoined(bool value) {
    setState(() {
      showMatrixJoinedFlag = value;
    });
  }

  Row selector(SettingsScreenNotifier notifier) {
    List<Widget> widgets = [];

    for (var val in ["black", "white"]) {
      var name = val;
      name = name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

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
            width: 30,
            height: 30,
            margin: EdgeInsets.only(right: val == "black" ? 10 : 0),
          ),
        ),
      );
    }

    widgets.add(
      Row(
        children: [
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: (() {
              setState(() {
                peekingColor = !peekingColor;
              });
            }),
            child: Container(
              width: 30,
              height: 30,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: !peekingColor ? Colors.white : Colors.grey,
              ),
              child: Image.asset("assets/dropper.png"),
            ),
          ),
        ],
      ),
    );

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: 40,
          padding: EdgeInsets.all(5),
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
      ],
    );
  }

  editPixel(
    int rowsCountIndex,
    int columnsCountIndex,
    int matrixRowsTextCountIndex,
    int matrixColumnsTextCountIndex,
  ) {
    if (peekingColor) {
      currentColor = colors[rowsCountIndex][columnsCountIndex][matrixRowsTextCountIndex][matrixColumnsTextCountIndex];

      posx = currentColor.blue.toInt() / 255 * 500;
      setState(() {
        peekingColor = false;
      });
      return;
    }
    setState(() {
      colors[rowsCountIndex][columnsCountIndex][matrixRowsTextCountIndex][matrixColumnsTextCountIndex] = currentColor;
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

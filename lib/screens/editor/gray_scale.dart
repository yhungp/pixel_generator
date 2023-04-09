// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/button.dart';
import 'package:calculator/screens/editor/widgets/hand_painting/code_from_colors_widget.dart';
import 'package:calculator/screens/editor/widgets/hand_painting/set_matrix_black_or_white.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/screens/editor/widgets/hand_painting/show_matrix_joined.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GreyScale extends StatefulWidget {
  int matrixColumns;
  int matrixRows;
  int columns;
  int rows;
  double scale;

  GreyScale({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.scale,
  }) : super(key: key);

  @override
  State<GreyScale> createState() => _GreyScaleState();
}

enum ColorOptions {
  black,
  white,
}

class _GreyScaleState extends State<GreyScale> {
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

  ColorOptions colorOptions = ColorOptions.black;

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
    return Consumer<SettingsScreenNotifier>(builder: (context, notifier, child) {
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
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: blueTheme(notifier.darkTheme),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onPanUpdate: (details) {
                              final tapPosition = details.localPosition;
                              if (tapPosition.dx > 0 && tapPosition.dx < 500) {
                                setState(() {
                                  posx = tapPosition.dx;
                                  currentColor = updateColor(posx);
                                });
                              }
                            },
                            onTapDown: (TapDownDetails details) {
                              final tapPosition = details.localPosition;
                              if (tapPosition.dx > 0 && tapPosition.dx < 500) {
                                setState(() {
                                  posx = tapPosition.dx;
                                  currentColor = updateColor(tapPosition.dx);
                                });
                              }
                            },
                            child: CustomPaint(
                              size: Size(370, 30),
                              painter: Rectangle(posx),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: currentColor,
                            ),
                          ),
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
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Visibility(
                      visible: peekingColor,
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: blueTheme(notifier.darkTheme),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          peekingColorLabel(notifier.language),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
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

  updateColor(double posx) {
    int scaled = (posx / 500 * 255).toInt();
    return Color.fromARGB(255, scaled, scaled, scaled);
  }

  Row selector(SettingsScreenNotifier notifier) {
    List<Widget> widgets = [];

    for (var val in ColorOptions.values) {
      var name = val.name;
      name = name.substring(0, 1).toUpperCase() + name.substring(1, name.length);

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
    colors[rowsCountIndex][columnsCountIndex][matrixRowsTextCountIndex][matrixColumnsTextCountIndex] = currentColor;
  }

  toogleMatrixJoined(bool value) {
    setState(() {
      showMatrixJoinedFlag = value;
    });
  }
}

class Rectangle extends CustomPainter {
  bool? isFilled;
  double posx;
  Rectangle(this.posx, {this.isFilled});

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    paint.shader = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Colors.white,
        Colors.black,
      ],
    ).createShader(rect);

    canvas.drawRect(rect, paint);

    rect = Offset(posx - 2, -2) & Size(4, size.height + 4);
    canvas.drawRect(rect, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return true;
  }
}

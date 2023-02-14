// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/array_of_matrix.dart';
import 'package:calculator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class RGB_Picker extends StatefulWidget {
  int matrixColumns;
  int matrixRows;
  int columns;
  int rows;
  double scale;

  RGB_Picker({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.scale,
  }) : super(key: key);

  @override
  State<RGB_Picker> createState() => _RGB_PickerState();
}

enum ColorOptions {
  black,
  white,
}

class _RGB_PickerState extends State<RGB_Picker> {
  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;
  double scale = 1;

  double posx = 0;
  double posy = 0;

  Color currentColor = Colors.white;

  List<List<List<List<Color>>>> colors = [];

  ColorOptions colorOptions = ColorOptions.black;

  bool peekingColor = false;

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

  void changeColor(Color color) {
    setState(() => currentColor = color);
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: blueTheme(notifier.darkTheme),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10),
                      // width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onPanUpdate: (details) {
                                  final tapPosition = details.localPosition;
                                  if (tapPosition.dx > 0 &&
                                      tapPosition.dx < 500) {
                                    setState(() {
                                      posx = tapPosition.dx;
                                      currentColor = updateColor(posx);
                                    });
                                  }
                                },
                                onTapDown: (TapDownDetails details) {
                                  final tapPosition = details.localPosition;
                                  if (tapPosition.dx > 0 &&
                                      tapPosition.dx < 500) {
                                    setState(() {
                                      posx = tapPosition.dx;
                                      currentColor = updateColor(posx);
                                    });
                                  }
                                },
                                child: CustomPaint(
                                  size: Size(200, 20),
                                  painter: Rectangle(
                                    posx,
                                    posy,
                                    gradient: true,
                                    color: currentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
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
                                  currentColor = updateColor(posx);
                                });
                              }
                            },
                            child: CustomPaint(
                              size: Size(200, 20),
                              painter: Rectangle(posx, posy),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: currentColor,
                              border: Border.all(
                                color: blackTheme(notifier.darkTheme),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              // paletteType: PaletteType.hueWheel,
              onColorChanged: (Color value) => changeColor(value),
            ),
          ),
        );
      },
    );
  }

  updateColor(double posx) {
    int scaled = (posx / 500 * 255).toInt();
    return Color.fromARGB(255, scaled, scaled, scaled);
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

  editPixel(
    int rowsCountIndex,
    int columnsCountIndex,
    int matrixRowsTextCountIndex,
    int matrixColumnsTextCountIndex,
  ) {
    if (peekingColor) {
      setState(() {
        currentColor = colors[rowsCountIndex][columnsCountIndex]
            [matrixRowsTextCountIndex][matrixColumnsTextCountIndex];

        posx = currentColor.blue.toInt() / 255 * 500;
      });
      return;
    }
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

class Rectangle extends CustomPainter {
  bool gradient;
  double posx;
  double posy;
  Color color;
  Rectangle(
    this.posx,
    this.posy, {
    this.gradient = false,
    this.color = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (gradient) {
      var rect = Offset(0, 0) & Size(size.width / 2, size.height);

      Paint paint = Paint();
      paint.shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        tileMode: TileMode.mirror,
        colors: [
          Colors.white,
          color,
        ],
      ).createShader(rect);

      canvas.drawRect(rect, paint);

      rect = Offset(size.width / 2, 0) & Size(size.width / 2, size.height);

      paint = Paint();
      paint.shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        tileMode: TileMode.mirror,
        colors: [
          color,
          Colors.black,
        ],
      ).createShader(rect);

      canvas.drawRect(rect, paint);

      // for (double i = 0; i <= size.height; i += 1) {
      //   int gray = ((size.height - i) / size.height * 255).toInt();
      //   var rect = Offset(0, i) & Size(size.width, 1);
      //   double percent = (size.height - i) / size.height * 255;

      //   Paint paint = Paint();
      //   paint.shader = LinearGradient(
      //     begin: Alignment.centerLeft,
      //     end: Alignment.centerRight,
      //     tileMode: TileMode.mirror,
      //     colors: [
      //       Color.fromARGB(255, gray, gray, gray),
      //       Color.fromARGB(255, percent.toInt(), percent.toInt(), 0)
      //     ],
      //   ).createShader(rect);

      //   canvas.drawRect(rect, paint);
      // }

      return;
    }

    var rect = Offset.zero & size;
    Paint paint = Paint();
    paint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [
        0.07,
        0.2857142857142857,
        0.42857142857142855,
        0.5714285714285714,
        0.7142857142857143,
        0.8571428571428571,
        1.0
      ],
      colors: [
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 255, 0),
        Color.fromARGB(255, 0, 255, 0),
        Color.fromARGB(255, 0, 255, 255),
        Color.fromARGB(255, 0, 0, 255),
        Color.fromARGB(255, 255, 0, 255),
        Color.fromARGB(255, 255, 0, 0),
      ],
    ).createShader(rect);

    canvas.drawRect(rect, paint);

    // rect = Offset(posx - 2, -2) & Size(4, size.height + 4);
    // canvas.drawRect(rect, Paint()..color = Colors.red);
  }

  Color darken(Color colorStart, Color colorEnd, double percent) {
    return Color.fromARGB(
      255,
      (colorStart.red + colorEnd.red) ~/ 2,
      colorStart.red + colorEnd.green ~/ 2,
      colorStart.red + colorEnd.blue ~/ 2,
    );
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return true;
  }
}

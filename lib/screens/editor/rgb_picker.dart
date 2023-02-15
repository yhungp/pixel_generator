// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/array_of_matrix.dart';
import 'package:calculator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;

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

  double posxGrayScale = 0;
  double posyGrayScale = 0;

  double posxColorBar = 0;
  double posyColorBar = 0;

  double posxMatrixPainter = 0;
  double posyMatrixPainter = 0;

  Color currentColor = Colors.white;
  Color rgbColor = Colors.red;

  List<List<List<List<Color>>>> colors = [];
  List<List<List<List<Rect>>>> rectangles = [];

  ColorOptions colorOptions = ColorOptions.black;

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

    // rectangles = List.generate(
    //   rows,
    //   (i) => List.generate(
    //     columns,
    //     (j) => List.generate(
    //       matrixRows,
    //       (x) => List.generate(
    //         matrixColumns,
    //         (y) => getOffset(i, j, x, y) & const Size(10, 10),
    //       ),
    //     ),
    //   ),
    // );

    super.initState();
  }

  // getOffset(i, j, x, y) {
  //   double dx = (j + x) * 13 + 13.0 * j * matrixColumns - 5 * j;
  //   double dy = (i + y) * 13 + 13.0 * i * matrixRows - 5 * i;
  //   return Offset(dx, dy);
  // }

  checkIfCoordinatesOnRectangle(double posx, double posy) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        for (int x = 0; x < matrixRows; x++) {
          for (int y = 0; y < matrixColumns; y++) {
            double dx = (j + x) * 13 + 13.0 * j * matrixColumns - 5 * j;
            double dy = (i + y) * 13 + 13.0 * i * matrixRows - 5 * i;

            bool pixelTouched =
                posx > dx && posx < dx + 10 && posy > dy && posy < dy + 10;

            if (pixelTouched) {
              editPixel(i, j, x, y, currentColor);
            }
          }
        }
      }
    }
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onPanUpdate: (details) {
                                  final tapPosition = details.localPosition;

                                  updatePosxGrayScale(
                                    tapPosition.dx,
                                    tapPosition.dy,
                                  );

                                  setState(() {
                                    grayScaleTouched = true;
                                  });
                                },
                                onTapDown: (TapDownDetails details) {
                                  final tapPosition = details.localPosition;

                                  updatePosxGrayScale(
                                    tapPosition.dx,
                                    tapPosition.dy,
                                  );

                                  setState(() {
                                    grayScaleTouched = true;
                                  });
                                },
                                onPanEnd: (_) {
                                  setState(() {
                                    grayScaleTouched = false;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    grayScaleTouched = false;
                                  });
                                },
                                child: CustomPaint(
                                  size: Size(200, 20),
                                  painter: Rectangle(
                                    posxGrayScale,
                                    posyGrayScale,
                                    rgbScaleTouched,
                                    grayScaleTouched,
                                    setGrayScaleColor,
                                    gradient: true,
                                    color: rgbColor,
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

                              updatePosxColorBar(
                                tapPosition.dx,
                                tapPosition.dy,
                              );

                              setState(() {
                                rgbScaleTouched = true;
                              });
                            },
                            onTapDown: (TapDownDetails details) {
                              final tapPosition = details.localPosition;

                              updatePosxColorBar(
                                tapPosition.dx,
                                tapPosition.dy,
                              );

                              setState(() {
                                rgbScaleTouched = true;
                              });
                            },
                            onPanEnd: (_) {
                              setState(() {
                                rgbScaleTouched = false;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                rgbScaleTouched = false;
                              });
                            },
                            child: CustomPaint(
                              size: Size(200, 20),
                              painter: Rectangle(
                                posxColorBar,
                                posyColorBar,
                                rgbScaleTouched,
                                grayScaleTouched,
                                setRgbColor,
                              ),
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
                                  editPixel,
                                ),
                              ),
                            ),
                            // arrayOfMatrix(
                            //   notifier,
                            //   rows,
                            //   columns,
                            //   matrixRows,
                            //   matrixColumns,
                            //   scale,
                            //   onClick: editPixel,
                            //   colors: colors,
                            // ),
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

  setRgbColor(Color color) {
    setState(() {
      rgbColor = color;
    });
  }

  setGrayScaleColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  updatePosxGrayScale(double dx, double dy) {
    if (dy < 0 || dy > 20) {
      return;
    }

    if (dx < 0) {
      setState(() {
        posxGrayScale = 0;
      });
      return;
    }

    if (dx > 200) {
      setState(() {
        posxGrayScale = 200;
      });
      return;
    }

    setState(() {
      posxGrayScale = dx;
    });
  }

  updatePosxColorBar(double dx, double dy) {
    if (dy < 0 || dy > 20) {
      return;
    }

    if (dx < 0) {
      setState(() {
        posxColorBar = 0;
      });
      return;
    }

    if (dx > 200) {
      setState(() {
        posxColorBar = 200;
      });
      return;
    }

    setState(() {
      posxColorBar = dx;
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

  updateColorGreyScale(double posx) {
    int scaled = (posx / 200 * 255).toInt();
    return Color.fromARGB(255, scaled, scaled, scaled);
  }

  updateColorFromColorBar(double posx) {
    int scaled = (posx / 200 * 255).toInt();
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
    int rIndex,
    int cIndex,
    int mrIndex,
    int mcIndex,
    Color color,
  ) {
    colors[rIndex][cIndex][mrIndex][mcIndex] = color;
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
  bool rgbScaleTouched;
  bool grayScaleTouched;
  double posx;
  double posy;
  Color color;
  Function setColor;

  Rectangle(
    this.posx,
    this.posy,
    this.rgbScaleTouched,
    this.grayScaleTouched,
    this.setColor, {
    this.gradient = false,
    this.color = Colors.white,
  });

  empty() {}

  @override
  void paint(Canvas canvas, Size size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvasToSave = Canvas(pictureRecorder);

    if (gradient) {
      var rect = Offset(0, 0) & Size(size.width / 2, size.height);

      Paint paint = Paint();
      paint.shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white,
          color,
        ],
      ).createShader(rect);

      canvas.drawRect(rect, paint);
      canvasToSave.drawRect(rect, paint);

      rect = Offset(size.width / 2, 0) & Size(size.width / 2, size.height);

      paint = Paint();
      paint.shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          color,
          Colors.black,
        ],
      ).createShader(rect);

      canvas.drawRect(rect, paint);

      if (grayScaleTouched || rgbScaleTouched) {
        canvasToSave.drawRect(rect, paint);

        final picture = pictureRecorder.endRecording();
        final exported = await picture.toImage(
          size.width.toInt(),
          size.height.toInt(),
        );

        final data = await exported.toByteData();
        final result = data!.buffer.asUint8List();

        var c = image.Image.fromBytes(
          size.width.toInt(),
          size.height.toInt(),
          result,
          format: image.Format.bgra,
        ).getPixel(
          posx.toInt(),
          10,
        );

        setColor(Color(c));
      }

      return;
    }

    var stops = [
      0.142857143,
      0.2857142857142857,
      0.42857142857142855,
      0.5714285714285714,
      0.7142857142857143,
      0.8571428571428571,
      1.0
    ];

    var colors = [
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 255, 255, 0),
      Color.fromARGB(255, 0, 255, 0),
      Color.fromARGB(255, 0, 255, 255),
      Color.fromARGB(255, 0, 0, 255),
      Color.fromARGB(255, 255, 0, 255),
      Color.fromARGB(255, 255, 0, 0),
    ];

    var rect = Offset.zero & size;
    Paint paint = Paint();
    paint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: stops,
      colors: colors,
    ).createShader(rect);

    canvas.drawRect(rect, paint);

    if (rgbScaleTouched) {
      canvasToSave.drawRect(rect, paint);

      final picture = pictureRecorder.endRecording();
      final exported = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );

      final data = await exported.toByteData();
      final result = data!.buffer.asUint8List();

      var c = image.Image.fromBytes(
        size.width.toInt(),
        size.height.toInt(),
        result,
        format: image.Format.bgra,
      ).getPixel(
        posx.toInt(),
        0,
      );

      // print(Color(c));
      // getColor(stops, colors, size.width);

      // setColor(getColor(stops, colors, size.width));
      setColor(Color(c));
    }

    // rect = Offset(posx - 2, -2) & Size(4, size.height + 4);
    // canvas.drawRect(rect, Paint()..color = Colors.red);
  }

  getColor(List stops, List colors, double width) {
    int counter = 0;

    for (var stop in stops) {
      if (posx / width <= stop) {
        break;
      }

      counter += 1;
    }

    double percent = 0;

    if (counter == stops.length - 1) {
      print("object");
    } else {
      double distance = stops[counter + 1] - stops[counter];
      double realPos = stops[counter] - posx / width;
      percent = realPos / distance;
    }

    if (counter == colors.length - 1) {
      return Colors.white;
    }

    Color start = colors[counter];
    Color end = colors[counter + 1];

    Color mid = middle(start, end, percent);
    print("$percent, $mid, $start, $end");

    return mid;
  }

  Color middle(Color colorStart, Color colorEnd, double percent) {
    return Color.lerp(colorStart, colorEnd, 1 - percent)!;
    // return Color.fromARGB(
    //   255,
    //   ((colorStart.red + colorEnd.red) / 2 * percent).toInt(),
    //   ((colorStart.green + colorEnd.green) / 2 * percent).toInt(),
    //   ((colorStart.blue + colorEnd.blue) / 2 * percent).toInt(),
    // );
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return true;
  }
}

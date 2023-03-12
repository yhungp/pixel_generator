// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/hand_painting/set_matrix_black_or_white.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/screens/editor/widgets/hand_painting/show_matrix_joined.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/utils/rgb_stops_and_colors.dart';
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

  double posxTone = 0;
  double posyGrayScale = 0;

  double posxColorBar = 0;
  double posyColorBar = 0;

  double posxMatrixPainter = 0;
  double posyMatrixPainter = 0;

  Color currentColor = Colors.white;
  Color rgbColor = Colors.red;

  List<List<List<List<Color>>>> colors = [];

  ColorOptions colorOptions = ColorOptions.black;

  bool peekingColor = false;
  bool toneTouched = false;
  bool rgbScaleTouched = false;
  bool matrixTouched = false;
  bool showMatrixJoinedFlag = false;

  @override
  void initState() {
    scale = widget.scale;
    matrixColumns = widget.matrixColumns;
    matrixRows = widget.matrixRows;
    columns = widget.columns;
    rows = widget.rows;

    setColors(Colors.white);

    super.initState();
  }

  toogleMatrixJoined(bool value) {
    setState(() {
      showMatrixJoinedFlag = value;
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

  checkIfCoordinatesOnRectangle(double posx, double posy) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        for (int x = 0; x < matrixRows; x++) {
          for (int y = 0; y < matrixColumns; y++) {
            double dx = (j + x) * 13 * scale + 13.0 * scale * j * matrixColumns - 5 * j;
            double dy = (i + y) * 13 * scale + 13.0 * scale * i * matrixRows - 5 * i;

            bool pixelTouched = posx > dx && posx < dx + 10 * scale && posy > dy && posy < dy + 10 * scale;

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
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: blueTheme(notifier.darkTheme),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onPanUpdate: changePosxColorBar,
                            onPanStart: changePosxColorBar,
                            onTapDown: changePosxColorBar,
                            onPanEnd: setRgbScaleTouched,
                            onTapUp: setRgbScaleTouched,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              child: CustomPaint(
                                size: Size(200, 30),
                                painter: Rectangle(
                                  posxColorBar,
                                  posyColorBar,
                                  rgbScaleTouched,
                                  toneTouched,
                                  setRgbColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                child: GestureDetector(
                                  onPanUpdate: updateTonePosition,
                                  onPanStart: updateTonePosition,
                                  onTapDown: updateTonePosition,
                                  onPanEnd: setToneTouchedFalse,
                                  onTapUp: setToneTouchedFalse,
                                  child: CustomPaint(
                                    size: Size(200, 30),
                                    painter: Rectangle(
                                      posxTone,
                                      posyGrayScale,
                                      rgbScaleTouched,
                                      toneTouched,
                                      setToneColor,
                                      gradient: true,
                                      color: rgbColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: currentColor,
                              border: Border.all(color: blackTheme(notifier.darkTheme)),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    ShowMatrixJoined(
                      showMatrixJoinedFlag: showMatrixJoinedFlag,
                      toogleMatrixJoined: toogleMatrixJoined,
                      notifier: notifier,
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
                                  showSpaceBetweenMatrix: !showMatrixJoinedFlag,
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

  void changePosxColorBar(details) {
    final tapPosition = details.localPosition;

    updatePosxColorBar(tapPosition.dx, tapPosition.dy);

    setState(() {
      rgbScaleTouched = true;
    });
  }

  void setRgbScaleTouched(_) {
    setState(() {
      rgbScaleTouched = false;
    });
  }

  void setToneTouchedFalse(_) {
    setState(() {
      toneTouched = false;
    });
  }

  void updateTonePosition(details) {
    final tapPosition = details.localPosition;

    updatePosxTone(tapPosition.dx, tapPosition.dy);

    setState(() {
      toneTouched = true;
    });
  }

  setRgbColor(Color color) {
    setState(() {
      rgbColor = color;
    });
  }

  setToneColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  updatePosxTone(double dx, double dy) {
    if (dy < 0 || dy > 20) {
      return;
    }

    if (dx < 0) {
      setState(() {
        posxTone = 0;
      });
      return;
    }

    if (dx > 200) {
      setState(() {
        posxTone = 200;
      });
      return;
    }

    setState(() {
      posxTone = dx;
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
    int rIndex,
    int cIndex,
    int mrIndex,
    int mcIndex,
    Color color,
  ) {
    colors[rIndex][cIndex][mrIndex][mcIndex] = color;
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

  @override
  void paint(Canvas canvas, Size size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvasToSave = Canvas(pictureRecorder);

    if (gradient) {
      var rect = Offset(0, 0) & Size(size.width / 2, size.height);

      Paint paint = Paint();
      paint.shader = getShader(rect, [0, 1], [Colors.white, color]);

      canvas.drawRect(rect, paint);
      canvasToSave.drawRect(rect, paint);

      rect = Offset(size.width / 2, 0) & Size(size.width / 2, size.height);

      paint = Paint();
      paint.shader = getShader(rect, [0, 1], [color, Colors.black]);

      canvas.drawRect(rect, paint);

      if (grayScaleTouched || rgbScaleTouched) {
        canvasToSave.drawRect(rect, paint);

        final picture = pictureRecorder.endRecording();
        await processTouch(picture, size);
      }

      return;
    }

    var rect = Offset.zero & size;
    Paint paint = Paint();
    paint.shader = getShader(rect, stops, colors);

    canvas.drawRect(rect, paint);

    if (rgbScaleTouched || grayScaleTouched) {
      canvasToSave.drawRect(rect, paint);

      final picture = pictureRecorder.endRecording();
      await processTouch(picture, size);
    }
  }

  getShader(Rect rect, List<double> stops, List<Color> colors) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: stops,
      colors: colors,
    ).createShader(rect);
  }

  processTouch(ui.Picture picture, Size size) async {
    final exported = await picture.toImage(size.width.toInt(), size.height.toInt());

    final data = await exported.toByteData();
    final result = data!.buffer.asUint8List();

    var c = image.Image.fromBytes(
      size.width.toInt(),
      size.height.toInt(),
      result,
      format: image.Format.bgra,
    ).getPixel(posx.toInt(), 10);

    setColor(Color(c));
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return true;
  }
}

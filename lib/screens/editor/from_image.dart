// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;

class From_Image extends StatefulWidget {
  int matrixColumns;
  int matrixRows;
  int columns;
  int rows;
  double scale;

  From_Image({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.scale,
  }) : super(key: key);

  @override
  State<From_Image> createState() => _From_ImageState();
}

class _From_ImageState extends State<From_Image> {
  late ui.Image imageFromFile;

  int matrixColumns = 8;
  int matrixRows = 8;
  int columns = 1;
  int rows = 1;
  int pointScaleTouched = 0;

  double scale = 1;

  double posxGrayScale = 0;
  double posyGrayScale = 0;

  double posxColorBar = 0;
  double posyColorBar = 0;

  double posxMatrixPainter = 0;
  double posyMatrixPainter = 0;

  double prevX = 0;
  double prevY = 0;

  double deltaX = 0;
  double deltaY = 0;

  double matrixWidth = 0;
  double matrixHeight = 0;

  Color currentColor = Colors.white;
  Color rgbColor = Colors.red;

  List<List<List<List<Color>>>> colors = [];

  bool peekingColor = false;
  bool grayScaleTouched = false;
  bool rgbScaleTouched = false;
  bool matrixScaleTouched = false;

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

    matrixWidth = matrixColumns * 13.0 * columns + (columns - 1) * 5 - 2;
    matrixHeight =
        posyMatrixPainter + matrixRows * 13.0 * rows + (rows - 1) * 5 - 2;

    super.initState();
  }

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  @override
  Widget build(BuildContext context) {
    // scale = 0.6;
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
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: blueTheme(notifier.darkTheme),
                      ),
                      height: 40,
                      child: Text(
                        peekingFileLabel(notifier.language),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: blueTheme(notifier.darkTheme),
                        ),
                        padding: EdgeInsets.all(5),
                        // margin: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 30,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: currentColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Text("TEST"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: currentColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Icon(Icons.file_open_outlined),
                            ),
                          ],
                        ),
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
                                setState(() {
                                  posxMatrixPainter += details.delta.dx;
                                  posyMatrixPainter += details.delta.dy;
                                });
                              },
                              onPanEnd: (_) {
                                setState(() {
                                  matrixScaleTouched = false;
                                });
                              },
                              child: CustomPaint(
                                size: Size(
                                  1920,
                                  600,
                                ),
                                painter: MatrixPainter(
                                  posxMatrixPainter,
                                  posyMatrixPainter,
                                  false,
                                  columns,
                                  matrixColumns,
                                  matrixRows,
                                  rows,
                                  matrixScaleTouched,
                                  currentColor,
                                  colors,
                                  scale,
                                  showSpaceBetweenMatrix: false,
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
            "Zoom: ${scale >= 2 ? scale.toStringAsFixed(0) : scale}",
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
    if (scale >= 2) {
      setState(() {
        scale += 1;
        scale = double.parse(scale.toStringAsFixed(1));
      });
      return;
    }
    if (scale <= 1.9) {
      setState(() {
        scale += 0.1;
        scale = double.parse(scale.toStringAsFixed(1));
      });
      return;
    }
    scale = 1;
  }

  downScale() {
    if (scale > 2) {
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

      setColor(Color(c));
    }
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return true;
  }
}

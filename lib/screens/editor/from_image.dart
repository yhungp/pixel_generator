// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/screens/editor/widgets/scale_button.dart';
import 'package:calculator/styles/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

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

  double posxMatrixPainter = 0;
  double posyMatrixPainter = 0;

  double matrixWidth = 0;
  double matrixHeight = 0;

  Color currentColor = Colors.white;
  Color rgbColor = Colors.red;

  List<List<List<List<Color>>>> colors = [];

  bool matrixScaleTouched = false;
  bool imagePeeked = false;
  bool sizeLoaded = false;

  String filePeeked = "";

  late Bitmap bmp;
  late Bitmap resized;
  late Uint8List imageBytes;

  late Timer timer;

  var widgetKey = GlobalKey();

  Size oldSize = Size(0, 0);

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

    timer =
        Timer.periodic(Duration(milliseconds: 40), (Timer t) => updateSize());

    super.initState();
  }

  updateSize() async {
    if (imagePeeked) {
      var context = widgetKey.currentContext;
      if (context == null) return;

      Size newSize = context.size!;
      if (oldSize == newSize) return;

      oldSize = newSize;

      resized = bmp.applyBatch([
        BitmapResize.to(
          // width: oldSize.width.toInt(),
          height: oldSize.height.toInt(),
        )
      ]);

      if (oldSize.width / bmp.width < oldSize.height / bmp.height) {
        resized = bmp.applyBatch([
          BitmapResize.to(
            width: oldSize.width.toInt(),
            // height: oldSize.height.toInt(),
          )
        ]);
      }

      imageBytes = bmp.buildHeaded();

      imageFromFile = await decodeImageFromList(resized.buildHeaded());

      setState(() {
        sizeLoaded = true;
      });
    }
  }

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  loadImage() async {
    if (!imagePeeked) {
      return;
    }
    imageFromFile = await _loadImage(filePeeked);
  }

  handleSavePressed() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    var painter = MatrixPainter(
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
      image: imageFromFile,
      imagePeeked: imagePeeked,
      showmatrix: false,
    );
    var size = widgetKey.currentContext!.size;

    painter.paint(canvas, size!);
    ui.Image renderedImage = await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());

    var pngBytes =
        await renderedImage.toByteData(format: ui.ImageByteFormat.png);

    Directory saveDir = await getApplicationDocumentsDirectory();
    File saveFile = File('${saveDir.path}/test.jpg');

    if (!saveFile.existsSync()) {
      saveFile.createSync(recursive: true);
    }
    saveFile.writeAsBytesSync(pngBytes!.buffer.asUint8List(), flush: true);
    print("end");
  }

  @override
  Widget build(BuildContext context) {
    // imagePeeked = false;
    // SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);

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
                      onTap: () => handleSavePressed(),
                      child: Container(
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
                                child: Text(
                                  filePeeked,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () => peekFile(),
                              child: Container(
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
                            !imagePeeked
                                ? Expanded(
                                    key: widgetKey,
                                    child: Center(
                                      child: Text(
                                        peekingFileLabel(
                                          notifier.language,
                                        ),
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    // key: widgetKey,
                                    child: Listener(
                                      onPointerSignal: (pointerSignal) {
                                        if (pointerSignal
                                            is PointerScrollEvent) {
                                          // do something when scrolled
                                          setState(() {
                                            if (pointerSignal.scrollDelta.dy <
                                                0) {
                                              scale += 0.01;
                                            } else {
                                              scale -= 0.01;
                                            }
                                          });
                                        }
                                      },
                                      child: GestureDetector(
                                        onPanUpdate: (details) {
                                          setState(() {
                                            posxMatrixPainter +=
                                                details.delta.dx;
                                            posyMatrixPainter +=
                                                details.delta.dy;
                                          });
                                        },
                                        onPanEnd: (_) {
                                          setState(() {
                                            matrixScaleTouched = false;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.zero,
                                          key: widgetKey,
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: !sizeLoaded
                                              ? Text("data")
                                              : CustomPaint(
                                                  size: Size(
                                                    oldSize.width,
                                                    oldSize.height,
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
                                                    showSpaceBetweenMatrix:
                                                        false,
                                                    image: imageFromFile,
                                                    imagePeeked: imagePeeked,
                                                  ),
                                                ),
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

  peekFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      filePeeked = result.files.single.path ?? "";
      try {
        var image = await _loadImage(filePeeked);
        imageFromFile = image;
        imagePeeked = true;
        setState(() {});
      } catch (e) {}
    }
  }

  _loadImage(String imageAssetPath) async {
    bmp = await Bitmap.fromProvider(FileImage(File(imageAssetPath)));

    resized = bmp;

    if (imagePeeked) {
      resized = bmp.applyBatch([
        BitmapResize.to(
          // width: oldSize.width.toInt(),
          height: oldSize.height.toInt(),
        )
      ]);

      if (oldSize.width / bmp.width < oldSize.height / bmp.height) {
        resized = bmp.applyBatch([
          BitmapResize.to(
            width: oldSize.width.toInt(),
            // height: oldSize.height.toInt(),
          )
        ]);
      }

      return imageFromFile = await decodeImageFromList(resized.buildHeaded());
    }

    return decodeImageFromList(bmp.buildHeaded());
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
}

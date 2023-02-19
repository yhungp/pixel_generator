// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/button.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/screens/editor/widgets/scale_button.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/generic_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image;
import 'package:video_thumbnail/video_thumbnail.dart';

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

  List<List<List<List<String>>>> pixels = [];

  @override
  void initState() {
    scale = widget.scale;
    matrixColumns = widget.matrixColumns;
    matrixRows = widget.matrixRows;
    columns = widget.columns;
    rows = widget.rows;

    pixels = List.generate(
      rows,
      (index) => List.generate(
        columns,
        (index) => List.generate(
          matrixRows,
          (index) => List.generate(
            matrixColumns,
            (index) => "",
          ),
        ),
      ),
    );

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
      0,
      0,
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
    File saveFile = File('${saveDir.path}/test.png');

    if (!saveFile.existsSync()) {
      saveFile.createSync(recursive: true);
    }
    saveFile.writeAsBytesSync(pngBytes!.buffer.asUint8List(), flush: true);

    image.Image img = image.decodeImage(saveFile.readAsBytesSync())!;

    var left = posxMatrixPainter.toInt() + 1;
    var top = posyMatrixPainter.toInt() + 1;
    var w = columns * matrixColumns * 13 * scale;
    var h = rows * matrixRows * 13 * scale;

    image.Image cropResize = image.copyCrop(
      img,
      left,
      top,
      w.toInt(),
      h.toInt(),
    );

    saveFile.writeAsBytesSync(
      Uint8List.fromList(image.encodeJpg(cropResize)),
      flush: true,
    );

    cropResize = image.copyResize(
      cropResize,
      width: columns * matrixColumns,
      height: rows * matrixRows,
    );

    saveFile.writeAsBytesSync(
      Uint8List.fromList(image.encodePng(cropResize)),
      flush: true,
    );

    List<List<int>> imgArray = [];
    final decodedBytes = cropResize.getBytes(format: image.Format.rgb);

    int loopLimit = matrixColumns * matrixRows * rows * columns;
    List<String> values = [];
    for (int x = 0; x < loopLimit; x++) {
      int red = decodedBytes[x * 3];
      int green = decodedBytes[x * 3 + 1];
      int blue = decodedBytes[x * 3 + 2];
      imgArray.add([red, green, blue]);
      values.add("0x${getHex(red)}${getHex(green)}${getHex(blue)}");
    }

    List<image.Image> images = [];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        image.Image im = image.copyCrop(
          cropResize,
          c * matrixColumns,
          r * matrixRows,
          matrixColumns,
          matrixRows,
        );

        images.add(im);
      }
    }

    List matrixValues = [];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        bool invert = false;
        image.Image im = images[r * (rows - 1) + c];
        final decodedBytes = im.getBytes(format: image.Format.rgb);

        List<String> values = [];
        int loopLimit = matrixColumns * matrixRows;
        for (int x = 0; x < loopLimit; x++) {
          int red = decodedBytes[x * 3];
          int green = decodedBytes[x * 3 + 1];
          int blue = decodedBytes[x * 3 + 2];
          imgArray.add([red, green, blue]);
          values.add("0x${getHex(red)}${getHex(green)}${getHex(blue)}");
        }

        for (int mr = 0; mr < matrixRows; mr++) {
          var row = values.sublist(
            mr * matrixColumns,
            mr * matrixColumns + matrixColumns,
          );

          if (!invert) {
            matrixValues.addAll(row);
            invert = true;
            continue;
          }

          row = row.reversed.toList();
          matrixValues.addAll(row);

          invert = false;
        }

        // for (int mr = 0; mr < matrixRows; mr++) {
        //   if (!invert) {
        //     for (int mc = 0; mc < matrixColumns; mc++) {
        //       Color pixel = Color(abgrToArgb(cropResize.getPixelSafe(
        //           c * matrixColumns + mc, r * matrixRows + mr)));
        //       int red = pixel.red;
        //       int green = pixel.green;
        //       int blue = pixel.blue;
        //       matrixValues
        //           .add("0x${getHex(green)}${getHex(red)}${getHex(blue)}");
        //     }
        //     invert = true;
        //     continue;
        //   }
        //   for (int mc = matrixColumns - 1; mc >= 0; mc--) {
        //     Color pixel = Color(abgrToArgb(cropResize.getPixelSafe(
        //         c * matrixColumns + mc, r * matrixRows + mr)));
        //     int red = pixel.red;
        //     int green = pixel.green;
        //     int blue = pixel.blue;
        //     matrixValues.add("0x${getHex(red)}${getHex(green)}${getHex(blue)}");
        //   }
        //   invert = false;
        // }
      }
    }

    // var invert = false;
    // for (int r = 0; r < rows * matrixRows - 1; r++) {
    //   for (int c = 0; c < columns * matrixColumns - 1; c++) {
    //     // if (!invert){
    //     //   invert = true;
    //     //   continue;
    //     // }
    //     var row = values.sublist(
    //         r * matrixColumns, r * matrixColumns + matrixColumns);
    //     row = row.reversed.toList();
    //     for (int c = 0; c < matrixColumns - 1; c++) {
    //       values[r * matrixColumns + c] = row[c];
    //     }
    //     invert = false;
    //   }
    // }

    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString("{\n\t${matrixValues.join(", ")}\n};");

    print("end  ${matrixValues.length} pixels");
  }

  getHex(int val) {
    String out = val.toRadixString(16);

    out = "0" * (2 - out.length) + out;
    return out;
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: viewScale(notifier),
                  ),
                  Expanded(child: Container()),
                  Visibility(
                    visible: imagePeeked,
                    child: EditorButton(
                      label: generateCode(notifier.language),
                      func: handleSavePressed,
                      darkTheme: notifier.darkTheme,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
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

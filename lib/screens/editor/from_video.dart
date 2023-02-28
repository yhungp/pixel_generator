// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/api_calls/api_calls.dart';
import 'package:calculator/screens/editor/widgets/button.dart';
import 'package:calculator/screens/editor/widgets/matrix_painter.dart';
import 'package:calculator/screens/editor/widgets/scale_button.dart';
import 'package:calculator/screens/editor/widgets/show_hide_code.dart';
import 'package:calculator/screens/editor/widgets/video_control/video_control.dart';
import 'package:calculator/styles/styles.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image;
import 'package:process_run/shell.dart';

class From_Video extends StatefulWidget {
  int matrixColumns;
  int matrixRows;
  int columns;
  int rows;
  double scale;

  From_Video({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.scale,
  }) : super(key: key);

  @override
  State<From_Video> createState() => _From_VideoState();
}

class _From_VideoState extends State<From_Video> {
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
  double posxStart = 0;
  double posxEnd = 0;

  Color currentColor = Colors.white;
  Color rgbColor = Colors.red;

  List<List<List<List<Color>>>> colors = [];

  bool matrixScaleTouched = false;
  bool imagePeeked = false;
  bool sizeLoaded = false;
  bool codeGenerated = false;
  bool showCode = false;
  bool playPause = false;
  bool videoLoaded = false;
  bool newVideoLoaded = false;

  String filePeeked = "";

  late Bitmap bmp;
  late Bitmap resized;
  late Uint8List imageBytes;

  late Timer timer;
  late Timer timer2;

  var widgetKey = GlobalKey();

  Size oldSize = Size(0, 0);

  List<String> pixels = [];

  final random = Random();

  late Player player;

  late Media file;

  List<Media> medias = <Media>[];

  @override
  void initState() {
    DartVLC.initialize();

    scale = widget.scale;
    matrixColumns = widget.matrixColumns;
    matrixRows = widget.matrixRows;
    columns = widget.columns;
    rows = widget.rows;

    var procId = random.nextInt(1000000) + 1000000;
    player = Player(id: procId);

    pixels = List.generate(
      rows * columns * matrixRows * matrixColumns,
      (index) => "",
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
    matrixHeight = posyMatrixPainter + matrixRows * 13.0 * rows + (rows - 1) * 5 - 2;

    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateSize());

    player.playbackStream.listen((playback) {
      setState(() {
        playPause = playback.isPlaying;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    medias.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    player.setVolume(0);
    return Consumer<SettingsScreenNotifier>(builder: (context, notifier, child) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Container()),
                  Visibility(
                    visible: imagePeeked && codeGenerated,
                    child: EditorButton(
                      label: showCodeLabel(notifier.language, showCode),
                      func: () => showHideCode(),
                      darkTheme: notifier.darkTheme,
                    ),
                  ),
                  SizedBox(width: 10),
                  Visibility(
                    visible: imagePeeked,
                    child: EditorButton(
                      label: generateCode(notifier.language),
                      func: () => handleSavePressed(notifier),
                      darkTheme: notifier.darkTheme,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: videoLoaded,
                child: SizedBox(
                  height: 10,
                ),
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
                    showCode
                        ? ShowHideCodeWidget(
                            notifier: notifier,
                            values: pixels,
                            rows: rows,
                            columns: columns,
                            matrixRows: matrixRows,
                            matrixColumns: matrixColumns,
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
                                      : videoPlayer(),
                                  SizedBox(height: 10),
                                  Visibility(
                                    visible: imagePeeked,
                                    child: VideoControlWidget(
                                      notifier: notifier,
                                      playPauseVideo: playPauseVideo,
                                      playPause: playPause,
                                      player: player,
                                      width: oldSize.width,
                                      setPosStart: setPosStart,
                                      setPosEnd: setPosEnd,
                                    ),
                                  )
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

  Expanded videoPlayer() {
    return Expanded(
      key: widgetKey,
      child: Stack(
        children: [
          Center(
            child: GestureDetector(
              child: Video(
                player: player,
                width: oldSize.width > 0 ? oldSize.width - 1 : 600,
                height: oldSize.height > 0 ? oldSize.height - 1 : 400,
                scale: 1.0,
                showControls: false,
              ),
            ),
          ),
          SizedBox(
            width: oldSize.width > 0 ? oldSize.width - 1 : 600,
            height: oldSize.height > 0 ? oldSize.height - 1 : 400,
            child: Column(
              children: [
                Expanded(
                  child: Listener(
                    onPointerSignal: (pointerSignal) {
                      if (pointerSignal is PointerScrollEvent) {
                        // do something when scrolled
                        setState(() {
                          if (pointerSignal.scrollDelta.dy < 0) {
                            scale += 0.01;
                          } else {
                            scale -= 0.01;
                          }
                        });
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        playPauseVideo();
                      },
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
                      child: Container(
                        padding: EdgeInsets.zero,
                        width: double.infinity,
                        height: double.infinity,
                        child: !videoLoaded
                            ? Text(
                                "data",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
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
                                  widget.scale,
                                  showSpaceBetweenMatrix: false,
                                  showOnlyPixels: true,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  playPauseVideo() {
    setState(() {
      playPause = !playPause;

      if (playPause) {
        var millis = (player.position.duration!.inMilliseconds * posxStart).toInt();
        player.seek(Duration(milliseconds: millis));

        player.play();
        return;
      }
      player.pause();
    });
  }

  setPosStart(double start) {
    setState(() {
      posxStart = start;
    });
  }

  setPosEnd(double end) {
    setState(() {
      posxEnd = end;
    });
  }

  execScriptAndGetFrames() async {
    var shell = Shell();
    await shell.run("python3 assets/test.py");
  }

  startServer() async {
    await Process.run('python3', ["assets/server.py"]);
  }

  updateSize() async {
    if (imagePeeked) {
      var context = widgetKey.currentContext;
      if (context == null) return;

      Size newSize = context.size!;

      if (newVideoLoaded) {
        setState(() {
          oldSize = Size(newSize.width, newSize.height);
          newVideoLoaded = false;
        });
        return;
      }

      if (oldSize == newSize) return;

      setState(() {
        oldSize = Size(newSize.width, newSize.height);
      });
    }
  }

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  handleSavePressed(SettingsScreenNotifier notifier) async {
    try {
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

      ui.Image renderedImage = await recorder.endRecording().toImage(
            size.width.floor(),
            size.height.floor(),
          );

      var pngBytes = await renderedImage.toByteData(format: ui.ImageByteFormat.png);

      image.Image img = image.decodeImage(pngBytes!.buffer.asUint8List())!;

      var left = posxMatrixPainter.toInt() + 1;
      var top = posyMatrixPainter.toInt() + 1;
      var w = columns * matrixColumns * 13 * scale;
      var h = rows * matrixRows * 13 * scale;

      image.Image cropResize = image.copyResize(
        image.copyCrop(
          img,
          left,
          top,
          w.toInt(),
          h.toInt(),
        ),
        width: columns * matrixColumns,
        height: rows * matrixRows,
      );

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

      List<String> matrixValues = [];
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
        }
      }

      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/my_file.txt');
      await file.writeAsString("{\n\t${matrixValues.join(", ")}\n};");

      showAlertDialog(
        "title",
        generationProcess(notifier.language, true),
      );

      setState(() {
        codeGenerated = true;
        pixels = matrixValues;
      });
    } catch (_) {
      showAlertDialog(
        "title",
        generationProcess(notifier.language, false),
      );

      setState(() {
        codeGenerated = true;
      });
    }
  }

  getHex(int val) {
    String out = val.toRadixString(16);

    out = "0" * (2 - out.length) + out;
    return out;
  }

  showAlertDialog(String title, String msg) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: widgetKey.currentContext!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showHideCode() {
    setState(() {
      showCode = !showCode;
    });
  }

  peekFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mkv'],
    );

    if (result != null && result.files.single.path != null) {
      var video = result.files.single.path ?? "";

      setVideoPath(video);
      imagePeeked = true;
      newVideoLoaded = true;
      setState(() {});
    }
  }

  Future<Uint8List> setVideoFrame() async {
    var response = await getFrame();
    return Uint8List.fromList(response['bytes']);
  }

  Future<ui.Image> _loadImage(String imageAssetPath) async {
    Uint8List bytes = await setVideoFrame();
    imageBytes = bytes;

    ui.Image i = await decodeImageFromList(bytes);

    bmp = Bitmap.fromHeadless(i.width, i.height, bytes);

    resized = bmp;

    return i;
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

  setVideoPath(String video) {
    try {
      if (medias.isNotEmpty) {
        try {
          player.dispose();
          var procId = random.nextInt(1000000) + 1000000;
          player = Player(id: procId);
        } catch (_) {}

        medias.clear();
      }

      file = Media.file(
        File(
          video,
        ),
      );

      medias.add(file);

      player.open(
        Playlist(
          medias: medias,
        ),
        autoStart: false,
      );
      player.setVolume(0);

      setState(() {
        filePeeked = video;
        videoLoaded = true;
        playPause = false;
      });
    } catch (_) {}
  }
}

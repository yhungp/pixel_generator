// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors, empty_catches, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:calculator/main.dart';
import 'package:calculator/screens/media_selector/widgets/media_control_button.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:process_run/shell.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';
import 'package:image/image.dart' as img;
import 'package:process_run/which.dart';

class MediaSelector extends StatefulWidget {
  bool darkTheme;
  int language;
  String filePath;

  MediaSelector({
    Key? key,
    required this.darkTheme,
    required this.language,
    required this.filePath,
  }) : super(key: key);

  @override
  State<MediaSelector> createState() => _MediaSelectorState();
}

class _MediaSelectorState extends State<MediaSelector> {
  var imageLoaded = false;
  late Image im;

  late Uint8List imBytes;
  late Uint8List resizedImg;

  late ui.Image _image;

  late Timer timer;

  late Process process;

  @override
  void initState() {
    startServer();

    timer = Timer.periodic(
      Duration(milliseconds: 33),
      (Timer t) => fetchImage(),
    );

    super.initState();
  }

  bool playPause = true;

  startServer() async {
    // var shell = Shell();
    // await shell.run("python3 assets/server.py");
    var result = await Process.run('python3', ["assets/server.py"]);
    print(result.stdout);
    // test(
    //   'pub get gets dependencies',
    //   () async {
    //     var process = await TestProcess.start('python3', ["assets/server.py"]);
    //     await process.shouldExit(0);
    //   },
    // );
    // try {
    //   process = await Process.start('python3', ["assets/server.py"]);
    // } catch (e) {
    //   print(e);
    // }
  }

  Stream getOutput() async* {
    var p = await Process.start('python3', ["assets/test.py"]);
    yield* p.stdout.transform(utf8.decoder);
  }

  @override
  void dispose() {
    // process.kill();
    timer.cancel();
    super.dispose();
  }

  fetchImage() async {
    if (!playPause) {
      try {
        final response = await http.get(Uri.parse('http://127.0.0.1:5000/'));

        if (response.statusCode == 200) {
          List l = jsonDecode(response.body)["bytes"];
          List<int> bytes = [];

          for (var byte in l) {
            bytes.add(int.parse(byte.toString()));
          }

          im = Image.memory(Uint8List.fromList(bytes));
          imBytes = Uint8List.fromList(bytes);

          // img.Image? image = img.decodeImage(bytes);
          // img.Image resized = img.copyResize(
          //   image!,
          //   width: 390,
          //   height: (390 / image.width * image.height).toInt(),
          // );

          // resizedImg = Uint8List.fromList(img.encodePng(resized));

          // final ui.Codec codec = await ui.instantiateImageCodec(resizedImg);

          final ui.Codec codec = await ui.instantiateImageCodec(imBytes);

          final ui.Image _im = (await codec.getNextFrame()).image;
          setState(() {
            _image = _im;
            imageLoaded = true;
          });
        }
      } catch (e) {
        // print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsScreenNotifier>(
      builder: (context, notifier, child) {
        return Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          width: double.infinity,
          color: blackTheme(notifier.darkTheme),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: blueTheme(notifier.darkTheme),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Center(
                    child: imageLoaded
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: CustomPaint(
                              painter: Sky(_image),
                            ),
                          )
                        : Container(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        playButtons(
                          () {
                            setState(() {
                              playPause = !playPause;
                            });
                          },
                          notifier,
                          Icons.fast_rewind_rounded,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  playButtons(
                    () {
                      setState(() {
                        playPause = !playPause;
                      });
                    },
                    notifier,
                    playPause ? Icons.play_arrow : Icons.pause,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        playButtons(
                          () {
                            setState(() {
                              playPause = !playPause;
                            });
                          },
                          notifier,
                          Icons.fast_forward_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class ImageEditor extends CustomPainter {
  ui.Image image;

  ImageEditor(this.image) : super();

  @override
  Future paint(Canvas canvas, Size size) async {
    canvas.drawImage(image, const Offset(0.0, -100.0), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Sky extends CustomPainter {
  ui.Image image;
  Sky(this.image) : super();

  @override
  void paint(Canvas canvas, Size size) {
    var scale = size.height / image.height;

    if (size.width / image.width > scale) {
      scale = size.width / image.width;
    }

    canvas.scale(scale);

    var x = (size.width - image.width) / 2;
    var y = (size.height - image.height) / 2;

    Rect rect = Offset(x, y) &
        Size(
          image.width.toDouble(),
          image.height.toDouble(),
        );
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      Rect rect = Offset.zero & size;
      final double width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}

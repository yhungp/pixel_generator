// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/utils/epoch_to_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:process_run/shell.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'dart:ui' as ui;

class VideoOutputConfiguration extends StatefulWidget {
  SettingsScreenNotifier notifier;
  List<String> values;
  int rows;
  int columns;
  int matrixRows;
  int matrixColumns;
  int duration;

  double scale;
  double posx;
  double posy;
  double posxStart;
  double posxEnd;

  String video;

  Size size;

  VideoOutputConfiguration({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.notifier,
    required this.values,
    required this.video,
    required this.scale,
    required this.posx,
    required this.posy,
    required this.size,
    required this.posxStart,
    required this.posxEnd,
    required this.duration,
  }) : super(key: key);

  @override
  State<VideoOutputConfiguration> createState() => _VideoOutputConfigurationState();
}

class _VideoOutputConfigurationState extends State<VideoOutputConfiguration> {
  late SettingsScreenNotifier notifier;
  late List<String> values;
  late int rows;
  late int columns;
  late int matrixRows;
  late int matrixColumns;

  late double scale;
  late double posx;
  late double posy;

  late Size size;

  double fps = 0;

  int height = 0;
  int width = 0;
  int startMillis = 0;
  int endMillis = 0;

  String duration = "";
  String temp = "";

  bool generating = true;

  List<Uint8List> bytesList = [];

  @override
  void initState() {
    // initialize variables
    notifier = widget.notifier;
    values = widget.values;
    rows = widget.rows;
    columns = widget.columns;
    matrixRows = widget.matrixRows;
    matrixColumns = widget.matrixColumns;
    scale = widget.scale;
    posx = widget.posx;
    posy = widget.posy;
    size = widget.size;
    startMillis = (widget.posxStart * widget.duration).toInt();
    endMillis = (widget.posxEnd * widget.duration).toInt();
    fpsController.text = "5";

    temp = "temp_${getRandomString(15)}";

    // generateVideoFrames();
    getVideoInfo();

    super.initState();
  }

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  var chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: blueTheme(notifier.darkTheme),
        ),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  informationTable(matrixData(), ouputMatrixInformationTable(notifier.language)),
                  informationTable(videoInfo(), ouputVideoInformationTable(notifier.language)),
                  informationTable(startEnd(), ouputStartAndEnd(notifier.language)),
                ],
              ),
              fpsTextField(),
              generating
                  ? Expanded(
                      child: Center(
                        child: TextButton(
                          onPressed: () => generateVideoFrames(),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              ouputGenerateFramesButton(notifier.language),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Expanded(
                              child: listOfImages(),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => {},
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Text(
                                      ouputCreateCodeButton(notifier.language),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  listOfImages() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Row(
          children: [
            for (var elem in bytesList)
              Container(
                height: 110,
                width: 110,
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                child: FittedBox(
                  fit: width >= height ? BoxFit.fitWidth : BoxFit.fitHeight,
                  child: Image.memory(elem),
                ),
              ),
          ],
        )
      ],
    );
  }

  TextEditingController fpsController = TextEditingController();
  fpsTextField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            fromVideoFpsSelectorLable(notifier.language),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
            child: TextField(
              controller: fpsController,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                if (value.isEmpty || value == "0") {
                  setState(() {
                    fpsController.text = "5";
                  });
                  return;
                }
                int val = int.tryParse(value) ?? 5;
                if (val > fps) {
                  setState(() {
                    fpsController.text = fps.toInt().toString();
                  });
                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  generateVideoFrames() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    bytesList.clear();

    Directory d = Directory("$tempPath/pixel_generator/$temp/");

    while (!d.existsSync()) {
      d.createSync(recursive: true);
    }

    var w = columns * matrixColumns;
    var h = rows * matrixRows;

    Map sizeRescaled = rescaledDimPos();
    int x = sizeRescaled["x"];
    int y = sizeRescaled["y"];
    int mw = sizeRescaled["w"];
    int mh = sizeRescaled["h"];

    int fps = int.tryParse(fpsController.text) ?? 5;

    List args = [
      "-t $tempPath/pixel_generator/$temp/",
      "-n base",
      "-f ${widget.video}",
      "-c ${x}x$y",
      "-s ${mw}x$mh",
      "-r ${w}x$h",
      "-a $startMillis",
      "-e $endMillis",
      "-p $fps",
    ];

    var cmd = "python3 assets/generator.py ${args.join(" ")}";

    var shell = Shell();
    await shell.run(cmd);

    List dirList = Directory("$tempPath/pixel_generator/$temp/").listSync();

    for (var file in dirList) {
      File f = file;

      if (f.existsSync()) {
        bytesList.add(f.readAsBytesSync());
      }
    }

    setState(() {
      generating = false;
    });

    d.deleteSync(recursive: true);
  }

  rescaledDimPos() {
    double w = (columns * matrixColumns - 1) * 13 * scale + 10 * scale;
    double h = (rows * matrixRows - 1) * 13 * scale + 10 * scale;

    if (size.height <= size.width) {
      double showedH = size.height;
      double showedW = size.height / height * width;

      double x = (posx - (size.width - showedW) / 2) / showedW * width;
      double y = showedH / height * posy;

      try {
        return {
          "x": (x != double.infinity && x != double.nan) ? x.toInt() : 0,
          "y": (y != double.infinity && y != double.nan) ? y.toInt() : 0,
          "w": (w != double.infinity && w != double.nan) ? w.toInt() : 0,
          "h": (h != double.infinity && h != double.nan) ? h.toInt() : 0,
        };
      } catch (e) {
        return {"x": 0, "y": 0, "w": 0, "h": 0};
      }
    }

    double showedW = size.width;
    double showedH = size.width / width * height;

    double x = showedW / width * posx;
    double y = (posy - (size.height - showedH) / 2) / showedH * height;

    try {
      return {
        "x": (x != double.infinity && x != double.nan) ? x.toInt() : 0,
        "y": (y != double.infinity && y != double.nan) ? y.toInt() : 0,
        "w": (w != double.infinity && w != double.nan) ? w.toInt() : 0,
        "h": (h != double.infinity && h != double.nan) ? h.toInt() : 0,
      };
    } catch (e) {
      return {"x": 0, "y": 0, "w": 0, "h": 0};
    }
  }

  Widget informationTable(List values, String tableName) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 2, color: Colors.black),
            ),
            child: Column(
              children: [
                Text(
                  tableName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < values.length; i++)
                          Column(
                            children: [
                              Text(
                                values[i][0],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              i != values.length - 1 ? Divider() : Container(),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(
                      height: values.length * 30,
                      child: VerticalDivider(
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (int i = 0; i < values.length; i++)
                          Column(
                            children: [
                              Text(
                                values[i][1],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              i != values.length - 1 ? Divider() : Container(),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<List<String>> matrixData() {
    return [
      ["Columns", columns.toString()],
      ["Rows", rows.toString()],
      ["Matrix columns", matrixColumns.toString()],
      ["Matrix rows", matrixRows.toString()],
    ];
  }

  List<List<String>> videoInfo() {
    return [
      ["Width", width.toString()],
      ["Height", height.toString()],
      ["FPS", fps.toStringAsFixed(2)],
      ["Duration", duration],
    ];
  }

  List<List<String>> startEnd() {
    return [
      ["Start", epochToTimeText(startMillis)],
      ["End", epochToTimeText(endMillis)],
    ];
  }

  getVideoInfo() async {
    var shell = Shell();

    List args = [
      "-f /media/yanhung/Elements/twitter_20220619_184851.mp4",
      "-p fps",
    ];

    var out = await shell.run("python3 assets/get_video_info.py ${args.join(" ")}");
    fps = double.tryParse(out.outText) ?? 0;

    args = [
      "-f /media/yanhung/Elements/twitter_20220619_184851.mp4",
      "-p size",
    ];

    out = await shell.run("python3 assets/get_video_info.py ${args.join(" ")}");
    String size = out.outText;
    width = int.tryParse(size.split("x")[0].toString()) ?? 0;
    height = int.tryParse(size.split("x")[1].toString()) ?? 0;

    args = [
      "-f /media/yanhung/Elements/twitter_20220619_184851.mp4",
      "-p duration",
    ];

    out = await shell.run("python3 assets/get_video_info.py ${args.join(" ")}");
    duration = out.outText;

    setState(() {});
  }
}

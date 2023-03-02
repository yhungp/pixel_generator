// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class VideoOutputConfiguration extends StatefulWidget {
  SettingsScreenNotifier notifier;
  List<String> values;
  int rows;
  int columns;
  int matrixRows;
  int matrixColumns;

  VideoOutputConfiguration({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.rows,
    required this.notifier,
    required this.values,
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

  String temp = "";

  bool generating = true;

  List<Uint8List> bytesList = [];

  @override
  void initState() {
    notifier = widget.notifier;
    values = widget.values;
    rows = widget.rows;
    columns = widget.columns;
    matrixRows = widget.matrixRows;
    matrixColumns = widget.matrixColumns;

    temp = "temp_${getRandomString(15)}";

    generateVideoFrames();

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
                children: [
                  informationTable(matrixData()),
                ],
              ),
              generating
                  ? Expanded(
                      child: Center(
                        child: Text(
                          "Generating",
                        ),
                      ),
                    )
                  : Expanded(
                      child: listOfImages(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  listOfImages() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: bytesList.length,
      itemBuilder: (BuildContext context, int index) => Wrap(
        children: [
          SizedBox(
            height: 110,
            width: 110,
            child: Card(
              child: Center(
                child: Image.memory(bytesList[index]),
              ),
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

    List args = [
      "-t /home/yanhung/$temp/",
      "-n base",
      "-f /media/yanhung/Elements/twitter_20220619_184851.mp4",
      "-c 200x200",
      "-s 180x180",
      "-r 96x96",
      "-a 1000",
      "-e 5000",
      "-p 5",
    ];

    var cmd = "python3 assets/generator.py ${args.join(" ")}";

    var shell = Shell();
    await shell.run(cmd);

    List dirList = Directory("/home/yanhung/$temp/").listSync();

    for (var file in dirList) {
      File f = file;

      if (f.existsSync()) {
        bytesList.add(f.readAsBytesSync());
      }
    }

    setState(() {
      generating = false;
    });
  }

  Widget informationTable(List values) {
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < values.length; i++)
                      Column(
                        children: [
                          Text(values[i][0]),
                          i != values.length - 1 ? Divider() : Container(),
                        ],
                      ),
                  ],
                ),
                SizedBox(
                  height: values.length * 30,
                  child: VerticalDivider(
                    color: Colors.black,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < values.length; i++)
                      Column(
                        children: [
                          Text(values[i][1]),
                          i != values.length - 1 ? Divider() : Container(),
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
}

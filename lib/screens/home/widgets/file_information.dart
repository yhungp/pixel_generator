// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:calculator/language/home.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/utils/bytes_converter.dart';
import 'package:flutter/material.dart';

class FileInformation extends StatefulWidget {
  FileInformation({
    Key? key,
    required this.darkTheme,
    required this.fileName,
    required this.language, required}) : super(key: key);

  String fileName;
  bool darkTheme;
  int language;

  @override
  State<FileInformation> createState() => _FileInformationState();
}

class _FileInformationState extends State<FileInformation> {
  bool darkTheme = false;
  int language = 0;

  bool loadingInfo = false;
  bool fileExist = false;

  int fileSize = 0;

  @override
  void initState() {
    darkTheme = widget.darkTheme;
    language = widget.language;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkFileInfo();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(fileLocation(language), style: TextStyle(color: textColor(darkTheme))),
        Text(widget.fileName, style: TextStyle(color: textColor(darkTheme))),
        Visibility(
          visible: loadingInfo && !fileExist,
          child: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Text(fileDoNotExist(language)),
          )
        ),

        Visibility(
          visible: loadingInfo && fileExist,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(fileSizeLabel(language), style: TextStyle(color: textColor(darkTheme))),
              Text(formatBytes(fileSize, 2), style: TextStyle(color: textColor(darkTheme))),
            ],
          )
        ),
      ],
    );
  }

  checkFileInfo() async {
    File f = File(widget.fileName);
    if (f.existsSync()){
      setState(() {
        fileSize = f.lengthSync();
        loadingInfo = true;
        fileExist = true;
      });
      return;
    }
  }
}

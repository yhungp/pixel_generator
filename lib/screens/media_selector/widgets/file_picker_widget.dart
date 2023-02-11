// ignore_for_file: prefer_const_constructors

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Row filePickerWidget(
  SettingsScreenNotifier notifier,
  String video,
  Function setVideoPath,
) {
  return Row(
    children: [
      Expanded(
        child: Container(
          alignment: Alignment.centerLeft,
          height: 50,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          child: Text(
            video,
            style: TextStyle(
              color: blueTheme(
                notifier.darkTheme,
              ),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GestureDetector(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['mp4', 'mkv'],
          );

          if (result != null && result.files.single.path != null) {
            setVideoPath(result.files.single.path);
          } else {
            // User canceled the picker
          }
        },
        child: Container(
          height: 50,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.blueGrey,
          ),
          child: Icon(
            Icons.file_open,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

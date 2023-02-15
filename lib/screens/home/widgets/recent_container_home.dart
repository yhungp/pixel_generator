// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, depend_on_referenced_packages

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class RecentContainerHomeWidget extends StatefulWidget {
  RecentContainerHomeWidget({
    Key? key,
    required this.darkTheme,
    required this.fileName,
    required this.openProject,
    required this.editProject,
    required this.index,
    required this.setRecentSelected,
    required this.language,
    required this.notifier,
  }) : super(key: key);

  String fileName;
  bool darkTheme;
  int language;
  SettingsScreenNotifier notifier;

  Function openProject;
  Function editProject;
  Function setRecentSelected;

  int index;

  @override
  State<RecentContainerHomeWidget> createState() =>
      _RecentContainerHomeWidgetState();
}

class _RecentContainerHomeWidgetState extends State<RecentContainerHomeWidget> {
  String fileName = "";

  bool darkTheme = false;
  bool expand = false;

  late Function openProject;
  late SettingsScreenNotifier notifier;

  @override
  void initState() {
    fileName = widget.fileName;
    darkTheme = widget.darkTheme;
    openProject = widget.openProject;
    notifier = widget.notifier;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expand = !expand;
          widget.setRecentSelected(widget.index, widget.language);
        });
      },
      child: Container(
        width: 130,
        height: 160,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.grey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.file_present_rounded,
                size: 60, color: textColorRecentContainerHome()),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    p.basename(widget.fileName),
                    style: TextStyle(color: textColorRecentContainerHome()),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.openProject(fileName, notifier);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black87,
                      ),
                      child: Icon(
                        Icons.folder_open_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.editProject(fileName, notifier);
                    },
                    child: Container(
                      // width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black87,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

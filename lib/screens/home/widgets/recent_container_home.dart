// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class RecentContainerHomeWidget extends StatefulWidget {
  RecentContainerHomeWidget({
    Key? key,
    required this.darkTheme,
    required this.fileName,
    required this.openProject}
      ) : super(key: key);

  String fileName;
  bool darkTheme;
  Function openProject;

  @override
  State<RecentContainerHomeWidget> createState() => _RecentContainerHomeWidgetState();
}

class _RecentContainerHomeWidgetState extends State<RecentContainerHomeWidget> {

  String fileName = "";

  bool darkTheme = false;
  bool expand = false;

  late Function openProject;

  @override
  void initState() {
    fileName = widget.fileName;
    darkTheme = widget.darkTheme;
    openProject = widget.openProject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          expand = !expand;
        });
      },
      child: Container(
        width: 100,
        height: !expand ? 100 : 130,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.grey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_present_rounded,
              size: 60,
              color: textColorRecentContainerHome()
            ),
            Text(
              widget.fileName,
              style: TextStyle(color: textColorRecentContainerHome()),
              overflow: TextOverflow.ellipsis,
            ),
            Visibility(
              visible: expand,
                child: GestureDetector(
                  onTap: (){
                    print(fileName);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.black87
                    ),
                    child: Text(
                      "Open",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

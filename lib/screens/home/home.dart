// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:calculator/language/home.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/vertical_line.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  Function setRoute;
  bool darkTheme;
  int language;

  HomePage(
      {Key? key,
      required this.title,
      required this.setRoute,
      required this.darkTheme,
      required this.language})
      : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool darkTheme = false;
  int language = 0;

  List recentProjectHistory = [];

  @override
  void initState() {
    darkTheme = widget.darkTheme;
    language = widget.language;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackTheme(darkTheme),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Container(
                width: 250,
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        recentProjects(language),
                        style: TextStyle(color: textColor(darkTheme)),
                      ),
                    ),
                    Expanded(
                        child: recentProjectHistory.isEmpty
                            ? Center(
                                child: Text(noRecentProjectsToShow(language),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: textColor(darkTheme))),
                              )
                            : ListView.builder(
                                itemCount: recentProjectHistory.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Tooltip(
                                      verticalOffset: 8,
                                      message: recentProjectHistory[index],
                                      child: Text(recentProjectHistory[index],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: textColor(darkTheme))),
                                    ),
                                  );
                                },
                              ))
                  ],
                ),
              ),
              VerticalLine()
            ],
          )),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.all(5),
          //       decoration: BoxDecoration(
          //           color: blueTheme(darkTheme),
          //           borderRadius: BorderRadius.all(Radius.circular(5))),
          //       child: Text("New"),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }


  readRecentProjects() async {
    String home = "";
    Map<String, String> envVars = Platform.environment;
    if (Platform.isMacOS) {
      home = envVars['HOME']!;
    } else if (Platform.isLinux) {
      home = envVars['HOME']!;
    } else if (Platform.isWindows) {
      home = envVars['UserProfile']!;
    }

    if (!Directory("$home/Pixel Generator/").existsSync()){
      Directory("$home/Pixel Generator/").createSync();
      File("$home/Pixel Generator/recent.json").createSync();
    }
  }
}

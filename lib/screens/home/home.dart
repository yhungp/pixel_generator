// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:calculator/language/home.dart';
import 'package:calculator/screens/home/widgets/recent_container_home.dart';
import 'package:calculator/screens/home/widgets/recent_lateral_bar_component.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/horizontal_line.dart';
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
  List<bool> recentProjectComponentSelected = [];

  @override
  void initState() {
    darkTheme = widget.darkTheme;
    language = widget.language;

    readRecentProjects();

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
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey
                        ),
                        child: Text(
                          recentProjects(language),
                          style: TextStyle(color: Colors.black87),
                        ),
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
                                  return RecentLateralBarComponent(
                                    darkTheme: darkTheme,
                                    fileName: recentProjectHistory[index],
                                      openProject: openProject
                                  );
                                },
                              ))
                  ],
                ),
              ),
              VerticalLine(),
              Expanded(child: Column(
                children: [
                  Expanded(child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            // color: Colors.white,
                            child: ListView(
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    for (var recent in recentProjectHistory)
                                      RecentContainerHomeWidget(
                                          darkTheme: darkTheme,
                                          fileName: recent,
                                          openProject: openProject
                                      )
                                  ],
                                )
                              ],
                            ),
                          )
                      ),
                      VerticalLine(),
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(5),
                        width: 200,
                        child: Column(),
                      )
                    ],
                  )),
                  HorizontalLine(),
                  SizedBox(
                    height: 150,
                    child: Column(),
                  )
                ],
              ))
            ],
          )),
        ],
      ),
    );
  }

  openProject(){

  }

  setRecentSelected(){

  }

  // create app folder and recent projects file if it doesn't exist
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

    var dir = Directory("$home/Pixel Generator/");
    var file = File("$home/Pixel Generator/recent.json");

    if (!dir.existsSync()){
      dir.createSync();
      file.createSync();
      return;
    }

    if (file.existsSync()){
      try {
        // Read the file
        final contents = await file.readAsString();

        Map recent = jsonDecode(contents);
        
        if (recent.containsKey("recents") && recent["recents"].runtimeType == List){
          List r = recent["recents"];

          recentProjectHistory = r.where((element) => checkIsJsonFile(element.toString())).toList();
          recentProjectComponentSelected = List.generate(
              recentProjectHistory.length, (index) => false
          );
        }

        setState(() {});
        
        return;
      } catch (e) {
        // If encountering an error, return 0
        return;
      }
    }

    file.createSync();

    file.writeAsString("{\n    \"recents\": []\n}\n");
  }

  checkIsJsonFile(String elem){
    List elemSplit = elem.split(".");

    return elemSplit[elemSplit.length - 1] == "json";
  }
}

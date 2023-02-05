// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:calculator/language/home.dart';
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

  List resentProjectHistory = [];

  @override
  void initState() {
    darkTheme = widget.darkTheme;
    language = widget.language;

    readResentProjects();

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
                          resentProjects(language),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    Expanded(
                        child: resentProjectHistory.isEmpty
                            ? Center(
                                child: Text(noResentProjectsToShow(language),
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: textColor(darkTheme))),
                              )
                            : ListView.builder(
                                itemCount: resentProjectHistory.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Tooltip(
                                      verticalOffset: 8,
                                      message: resentProjectHistory[index],
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: (){},
                                            child: Text(resentProjectHistory[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: textColor(darkTheme))),
                                          ),
                                        ],
                                      ),
                                    ),
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
                      Expanded(child: Container()),
                      VerticalLine(),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                        width: 200,
                        child: Column(),
                      )
                    ],
                  )),
                  HorizontalLine(),
                  SizedBox(
                    height: 200,
                    child: Column(),
                  )
                ],
              ))
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

  // create app folder and resent projects file if it doesn't exist
  readResentProjects() async {
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
    var file = File("$home/Pixel Generator/resent.json");

    if (!dir.existsSync()){
      dir.createSync();
      file.createSync();
      return;
    }

    if (file.existsSync()){
      try {
        // Read the file
        final contents = await file.readAsString();

        Map resent = jsonDecode(contents);
        
        if (resent.containsKey("resents") && resent["resents"].runtimeType == List){
          List r = resent["resents"];
          resentProjectHistory = r.where((element) => checkIsJsonFile(element.toString())).toList();
        }
        setState(() {});
        
        return;
      } catch (e) {
        // If encountering an error, return 0
        return;
      }
    }

    file.createSync();

    file.writeAsString("{\n    \"resents\": []\n}\n");
  }

  checkIsJsonFile(String elem){
    List elemSplit = elem.split(".");

    return elemSplit[elemSplit.length - 1] == "json";
  }
}

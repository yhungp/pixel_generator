// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:calculator/language/home.dart';
import 'package:calculator/screens/home/widgets/file_information.dart';
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
  int selected = -1;
  int fileSize = 0;

  List recentProjectHistory = [];
  List<bool> recentProjectComponentSelected = [];
  List<int> recentProjectComponentFileSize = [];

  String fileContent = "";

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
                recentProjectHistory.isEmpty ?
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(noRecentProjectsToShow(language),
                            textAlign: TextAlign.center,
                            style:
                            TextStyle(color: textColor(darkTheme))),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                // width: double.infinity,
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.black87
                                ),
                                child: Text(
                                  createNewProject(language),
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            SizedBox(width: 10),

                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                // width: double.infinity,
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: Colors.black87
                                ),
                                child: Text(
                                  openExistingProject(language),
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
                :
                Expanded(child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                // color: Colors.white,
                                child: ListView(
                                  controller: ScrollController(),
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      children: generateListOfRecentCards(),
                                    )
                                  ],
                                ),
                              )
                          ),
                          VerticalLine(),
                          Container(
                            margin: EdgeInsets.all(5),
                            width: 250,
                            child: selected == -1 ? Container() :
                            FileInformation(
                              darkTheme: darkTheme,
                              fileName: recentProjectHistory[selected],
                              language: language,
                            ),
                          )
                        ],
                      )
                    ),
                    Visibility(child: HorizontalLine()),
                    Container(
                      padding: EdgeInsets.all(5),
                      height: 150,
                      child: Column(
                        children: [
                          Expanded(
                            child: ![
                                fileEmpty(language), errorLoadingFile(language)
                              ].contains(fileContent)
                              ? ListView(
                              controller: ScrollController(),
                              children: [
                                Text(
                                  fileContent,
                                  style: TextStyle(color: textColor(darkTheme)),
                                  textAlign: TextAlign.start
                                )
                              ],
                            ) :
                            Center(
                              child: Text(
                                fileContent,
                                style: TextStyle(color: textColor(darkTheme)),
                                textAlign: TextAlign.center,
                              ),
                            )
                          )
                        ],
                      ),
                    )
                  ],
                )
              )
            ],
          )),
        ],
      ),
    );
  }

  List<Widget> generateListOfRecentCards(){
    List<Widget> widget = [];

    int counter = 0;
    for (var recent in recentProjectHistory) {
      final int count = counter;
      widget.add(RecentContainerHomeWidget(
        darkTheme: darkTheme,
        fileName: recent,
        openProject: openProject,
        setRecentSelected: setRecentSelected,
        index: count,
      ));
      counter += 1;
    }

    return widget;
  }

  openProject(){

  }

  setRecentSelected(int index){
    setState(() {
      selected = index;
      setContent(index);

      fileSize = recentProjectComponentFileSize[index];
      recentProjectComponentSelected[index] = !recentProjectComponentSelected[index];
      recentProjectComponentSelected.asMap().forEach((i, _) {
        if ( i != index){
          recentProjectComponentSelected[index] = false;
          return;
        }

        recentProjectComponentSelected[index] = !recentProjectComponentSelected[index];
      });
    });
  }

  setContent(int index) async {
    var file = File(recentProjectHistory[index]);

    if (file.existsSync()){
      try {
        // Read the file
        final contents = await file.readAsString();

        Map recent = jsonDecode(contents);

        JsonEncoder encoder = JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(recent);

        if (prettyprint.replaceAll(" ", "").isEmpty){
          setState(() {
            fileContent = fileEmpty(language);
          });

          return;
        }

        setState(() {
          fileContent = prettyprint;
        });

        return;
      } catch (e) {
        setState(() {
          fileContent = errorLoadingFile(language);
        });
        return;
      }
    }
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
          recentProjectComponentFileSize = List.generate(
              recentProjectHistory.length, (index) => 0
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

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:calculator/language/home.dart';
import 'package:calculator/utils/prettyJSON.dart';
import 'package:calculator/widgets/generic_button.dart';
import 'package:calculator/screens/home/widgets/file_information.dart';
import 'package:calculator/screens/home/widgets/recent_container_home.dart';
import 'package:calculator/screens/home/widgets/recent_lateral_bar_component.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/widgets/horizontal_line.dart';
import 'package:calculator/widgets/vertical_line.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  Function setRoute;
  Function setProjectFile;
  bool darkTheme;
  int language;

  HomePage(
      {Key? key,
      required this.setRoute,
      required this.darkTheme,
      required this.language,
      required this.setProjectFile})
      : super(key: key);

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

  late Function setProjectFile;
  late Function setRoute;

  @override
  void initState() {
    darkTheme = widget.darkTheme;
    language = widget.language;
    setProjectFile = widget.setProjectFile;
    setRoute = widget.setRoute;

    readWriteRecentProjects();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: blackTheme(darkTheme),
      padding: const EdgeInsets.all(5.0),
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
                        color: Colors.grey),
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
                                style: TextStyle(color: textColor(darkTheme))),
                          )
                        : ListView.builder(
                            itemCount: recentProjectHistory.length,
                            itemBuilder: (context, index) {
                              return RecentLateralBarComponent(
                                  darkTheme: darkTheme,
                                  fileName: recentProjectHistory[index],
                                  openProject: openProject);
                            },
                          ))
              ],
            ),
          ),
          VerticalLine(),
          recentProjectHistory.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(noRecentProjectsToShow(language),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textColor(darkTheme))),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ButtonOnHome(
                                label: createNewProject(language),
                                func: newProject,
                                darkTheme: darkTheme),
                            SizedBox(width: 10),
                            ButtonOnHome(
                                label: openExistingProject(language),
                                func: openProjectFromDialog,
                                darkTheme: darkTheme),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
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
                        )),
                        VerticalLine(),
                        Container(
                          margin: EdgeInsets.all(5),
                          width: 250,
                          child: selected == -1
                              ? Container()
                              : FileInformation(
                                  darkTheme: darkTheme,
                                  fileName: recentProjectHistory[selected],
                                  language: language,
                                ),
                        )
                      ],
                    )),
                    Visibility(child: HorizontalLine()),
                    Container(
                      padding: EdgeInsets.all(5),
                      height: 150,
                      child: Column(
                        children: [
                          Expanded(
                              child: ![
                            fileEmpty(language),
                            errorLoadingFile(language)
                          ].contains(fileContent)
                                  ? ListView(
                                      controller: ScrollController(),
                                      children: [
                                        Text(fileContent,
                                            style: TextStyle(
                                                color: textColor(darkTheme)),
                                            textAlign: TextAlign.start)
                                      ],
                                    )
                                  : Center(
                                      child: Text(
                                        fileContent,
                                        style: TextStyle(
                                            color: textColor(darkTheme)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                        ],
                      ),
                    )
                  ],
                ))
        ],
      ),
    );
  }

  openProject(String path) {
    setProjectFile(path);
    setRoute("matrix_creation");
  }

  List<Widget> generateListOfRecentCards() {
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

  bool showAccept = false;
  openProjectFromDialog(BuildContext context) {
    TextEditingController dir = TextEditingController();

    Widget okButton = TextButton(
      child: Text("OK", style: TextStyle(color: Colors.grey)),
      onPressed: () {
        Navigator.of(context).pop();
        setProjectFile(dir.text);
        setRoute("matrix_creation");
        readWriteRecentProjects(readWrite: false, newFilePath: dir.text);
      },
    );

    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.grey)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setInnerState) {
          return AlertDialog(
            title: Text(existingProjectTitle(language),
                style: TextStyle(color: Color.fromARGB(255, 100, 100, 100))),
            content: Wrap(
              children: [
                SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(existingProjectMsg(language),
                          style: TextStyle(color: Colors.grey)),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 200, 200, 200),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))),
                                child: TextField(
                                  controller: dir,
                                  onChanged: (text) async {
                                    showAccept =
                                        await checkValidProjectFile(text);
                                    setInnerState(() {});
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: blueTheme(darkTheme),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Icon(Icons.search),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            actions: showAccept
                ? [
                    cancelButton,
                    okButton,
                  ]
                : [cancelButton],
          );
        });
      },
    );
  }

  Future<bool> checkValidProjectFile(String path) async {
    var file = File(path);

    if (!file.existsSync()) {
      return false;
    }

    try {
      // Read the file
      final contents = await file.readAsString();

      Map recent = jsonDecode(contents);

      if (recent.containsKey("matrix_columns") &&
          recent["matrix_columns"].runtimeType == int &&
          recent.containsKey("matrix_rows") &&
          recent["matrix_rows"].runtimeType == int &&
          recent.containsKey("columns") &&
          recent["columns"].runtimeType == int &&
          recent.containsKey("rows") &&
          recent["rows"].runtimeType == int) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  newProject() {}

  setRecentSelected(int index) {
    setState(() {
      selected = index;
      setContent(index);

      fileSize = recentProjectComponentFileSize[index];
      recentProjectComponentSelected[index] =
          !recentProjectComponentSelected[index];
      recentProjectComponentSelected.asMap().forEach((i, _) {
        if (i != index) {
          recentProjectComponentSelected[index] = false;
          return;
        }

        recentProjectComponentSelected[index] =
            !recentProjectComponentSelected[index];
      });
    });
  }

  setContent(int index) async {
    var file = File(recentProjectHistory[index]);

    if (file.existsSync()) {
      try {
        // Read the file
        final contents = await file.readAsString();

        Map recent = jsonDecode(contents);
        String prettyprint = prettyJson(recent);

        if (prettyprint.replaceAll(" ", "").isEmpty) {
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
  // readWrite: true -> read       false -> write
  readWriteRecentProjects(
      {bool readWrite = true, String newFilePath = ""}) async {
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

    if (!dir.existsSync()) {
      dir.createSync();
      file.createSync();

      if (!readWrite) {
        file.writeAsString(prettyJson({
          "recents": [newFilePath]
        }));
      }
      return;
    }

    if (file.existsSync()) {
      try {
        // Read the file
        final contents = await file.readAsString();

        Map recent = jsonDecode(contents);

        if (!readWrite) {
          List r = recent["recents"];
          r = List.from([newFilePath])..addAll(r);

          recent["recents"] = r;

          file.writeAsString(prettyJson(recent));
          return;
        }

        if (recent.containsKey("recents") &&
            recent["recents"].runtimeType == List) {
          List r = recent["recents"];

          recentProjectHistory = r
              .where((element) => checkIsJsonFile(element.toString()))
              .toList();
          recentProjectComponentSelected =
              List.generate(recentProjectHistory.length, (index) => false);
          recentProjectComponentFileSize =
              List.generate(recentProjectHistory.length, (index) => 0);
        }

        setState(() {});

        return;
      } catch (e) {
        return;
      }
    }

    file.createSync();

    if (readWrite) {
      file.writeAsString(prettyJson({"recents": []}));
      return;
    }

    file.writeAsString(prettyJson({
      "recents": [newFilePath]
    }));
  }

  checkIsJsonFile(String elem) {
    List elemSplit = elem.split(".");

    return elemSplit[elemSplit.length - 1] == "json";
  }
}

// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors, empty_catches, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:calculator/language/media_selector.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/media_selector/widgets/file_picker_widget.dart';
import 'package:calculator/styles/styles.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaSelector extends StatefulWidget {
  bool darkTheme;
  int language;
  String filePath;
  bool fromEdit = true;
  Function setRoute;
  Function setProjectFile;

  MediaSelector({
    Key? key,
    required this.darkTheme,
    required this.language,
    required this.filePath,
    required this.setProjectFile,
    required this.setRoute,
    this.fromEdit = false,
  }) : super(key: key);

  @override
  State<MediaSelector> createState() => _MediaSelectorState();
}

class _MediaSelectorState extends State<MediaSelector> {
  final GlobalKey _widgetKey = GlobalKey();

  String video = "";

  double screenW = 0;
  double screenH = 0;
  double videoW = 0;
  double videoH = 0;

  bool videoLoaded = false;

  late Timer timer;

  final player = Player(id: 69420);

  late Media file;

  List<Media> medias = <Media>[];

  bool fromEdit = false;

  @override
  void initState() {
    fromEdit = widget.fromEdit;

    timer = Timer.periodic(
      Duration(milliseconds: 40),
      (Timer t) => checkSizeChange(),
    );
    super.initState();
  }

  startServer() async {
    var result = await Process.run('python3', ["assets/server.py"]);
    print(result.stdout);
  }

  @override
  void dispose() {
    // process.kill();
    timer.cancel();
    player.dispose();
    super.dispose();
  }

  checkSizeChange() {
    try {
      final RenderBox renderBox =
          _widgetKey.currentContext?.findRenderObject() as RenderBox;

      final Size size = renderBox.size;

      if (size.width != screenW || size.height != screenH) {
        setState(() {
          screenW = size.width;
          screenH = size.height;
        });
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (video != "") {
      checkSizeChange();
    }

    return Consumer<SettingsScreenNotifier>(
      builder: (context, notifier, child) {
        return Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          width: double.infinity,
          color: blackTheme(notifier.darkTheme),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: blueTheme(notifier.darkTheme),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          key: _widgetKey,
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child: video != ""
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Video(
                                    player: player,
                                    width: screenW,
                                    height: screenH,
                                    // width: 1358,
                                    // height: 819,
                                    scale: 1.0, // default
                                    showControls: true, // default
                                  ),
                                )
                              : Text(
                                  peekFile(notifier.language),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: filePickerWidget(
                                  notifier, video, setVideoPath),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: fromEdit,
                    child: GestureDetector(
                      onTap: () {
                        widget.setRoute("matrix_creation");
                        notifier.setApplicationScreen(1);
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            // padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: blueTheme(notifier.darkTheme),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            backToMatrixCreation(
                              notifier.language,
                            ),
                            style: TextStyle(
                              color: backToMatrixCreationTheme(
                                notifier.darkTheme,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: 120,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: blueTheme(notifier.darkTheme),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        fromEdit
                            ? nextButton(
                                notifier.language,
                              )
                            : acceptVideo(
                                notifier.language,
                              ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  setVideoPath(String value) {
    medias.clear();

    file = Media.file(
      File(
        '/media/yanhung/Elements/twitter_20220619_184851.mp4',
      ),
    );

    medias.add(file);

    player.open(
      Playlist(
        medias: medias,
      ),
      autoStart: false,
    );

    setState(() {
      videoLoaded = true;
      video = value;
    });
  }
}

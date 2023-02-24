// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/video_control_button.dart';
import 'package:calculator/styles/styles.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

class VideoControlWidget extends StatefulWidget {
  SettingsScreenNotifier notifier;
  Function playPauseVideo;
  bool playPause;
  Player player;
  double width;

  VideoControlWidget({
    Key? key,
    required this.notifier,
    required this.playPause,
    required this.playPauseVideo,
    required this.player,
    required this.width,
  }) : super(key: key);

  @override
  State<VideoControlWidget> createState() => _VideoControlWidgetState();
}

class _VideoControlWidgetState extends State<VideoControlWidget> {
  late SettingsScreenNotifier notifier;
  late Function playPauseVideo;
  late bool playPause;
  late Player player;

  PositionState position = PositionState();

  late double width;
  double posxStart = 0;
  double posxEnd = 0;

  @override
  void initState() {
    notifier = widget.notifier;
    playPauseVideo = widget.playPauseVideo;
    playPause = widget.playPause;
    player = widget.player;

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    player.currentStream.listen((current) {
      setState(() => current = current);
    });
    player.positionStream.listen(
      (position) {
        setState(
          () => {
            posxStart = position.position!.inMilliseconds / position.duration!.inMilliseconds,
          },
        );
      },
    );
    player.playbackStream.listen((playback) {
      setState(() {
        playPause = playback.isPlaying;
      });
    });
    // player?.generateStream?.listen((general) {
    //   setState(() => general = general);
    // });
    // devices = await Devices.all;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    width = widget.width;

    return Column(
      children: [
        GestureDetector(
          onPanUpdate: (details) => setPlayerPosition(details.localPosition.dx),
          onPanStart: (details) => setPlayerPosition(details.localPosition.dx),
          child: Container(
            width: double.infinity,
            height: 15,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: posxStart * (width - 20),
                  top: 2.5,
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: blueTheme(!notifier.darkTheme),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
                Positioned(
                  left: (1 - posxEnd) * (width - 20),
                  top: 2.5,
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: blueTheme(!notifier.darkTheme),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 5,
                  child: Container(
                    width: posxStart * (width - 20),
                    height: 5,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: blueTheme(!notifier.darkTheme),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VideoControlButton(
                    func: () {},
                    darkTheme: notifier.darkTheme,
                    icon: Icons.replay_5,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            VideoControlButton(
              func: () {
                playPauseVideo();
                setState(() {
                  playPause = widget.playPause;
                });
              },
              darkTheme: notifier.darkTheme,
              icon: playPause ? Icons.pause : Icons.play_arrow,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VideoControlButton(
                    func: () {},
                    darkTheme: notifier.darkTheme,
                    icon: Icons.forward_5_rounded,
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 40,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "[ ${getPositionText()} - ${getDurationText()} ]",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  getPositionText() {
    String txt = player.position.position.toString();
    return txt.substring(0, txt.length - 3);
  }

  getDurationText() {
    String txt = player.position.duration.toString();
    return txt.substring(0, txt.length - 3);
  }

  setPlayerPosition(double localx) {
    try {
      if (localx > (1 - posxEnd) * (width - 20) - 5 && localx < (1 - posxEnd) * (width - 20) + 5) {
        print("end");
      }

      if (localx > width - 10) {
        setState(() {
          posxStart = 1;
          var millis = (player.position.duration!.inMilliseconds).toInt() - 1;
          player.seek(Duration(milliseconds: millis));
        });
        return;
      }

      if (localx > 10) {
        setState(() {
          posxStart = (localx - 12.5) / (width - 20);
          var millis = (player.position.duration!.inMilliseconds).toInt();
          millis = (millis * posxStart).toInt();
          player.seek(Duration(milliseconds: millis));
        });
        return;
      }

      setState(() {
        posxStart = 0;
        player.seek(Duration(seconds: 0));
      });
    } catch (_) {}
  }
}

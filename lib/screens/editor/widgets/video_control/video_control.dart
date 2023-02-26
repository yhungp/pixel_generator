// ignore_for_file: prefer_const_constructors, must_be_immutable, library_private_types_in_public_api

import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/video_control/video_control_button.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/utils/epoch_to_time.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

class VideoControlWidget extends StatefulWidget {
  SettingsScreenNotifier notifier;
  Function playPauseVideo;
  bool playPause;
  Player player;
  double width;
  Function setPosStart;
  Function setPosEnd;

  VideoControlWidget({
    Key? key,
    required this.notifier,
    required this.playPause,
    required this.playPauseVideo,
    required this.player,
    required this.width,
    required this.setPosStart,
    required this.setPosEnd,
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
  double playerPos = 0;
  double playerPosHover = 0;

  bool picked = false;
  bool hover = false;

  int selected = 0;

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
      (position) async {
        playerPos = position.position!.inMilliseconds / position.duration!.inMilliseconds;

        if (position.position!.inMilliseconds / position.duration!.inMilliseconds >= 1 - posxEnd) {
          playerPos = 1 - posxEnd - 1 / width;
          playerPos = playerPos < 0
              ? 0
              : playerPos > 1
                  ? 1
                  : playerPos;
          player.pause();
          playPause = false;
        }

        setState(() {});
      },
    );

    player.playbackStream.listen((playback) {
      setState(() {
        playPause = playback.isPlaying;

        if (!playPause && picked) {
          widget.player.play();
          player.play();
        }
      });
    });

    player.errorStream.listen((event) {
      setState(() {});
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
          onPanUpdate: (details) {
            setPlayerPosition(details.localPosition.dx);
          },
          onPanStart: (details) {
            setPlayerPosition(details.localPosition.dx);
          },
          onPanCancel: () {
            setState(() {
              picked = false;
            });
          },
          onPanEnd: ((details) {
            setState(() {
              picked = false;
              selected = -1;
            });
          }),
          child: Container(
            width: double.infinity,
            height: 15,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: MouseRegion(
              onHover: ((details) {
                setState(() {
                  hover = true;
                  playerPosHover = (details.localPosition.dx - 12.5) / (width - 20);

                  if (playerPosHover < 0) {
                    playerPosHover = 0;
                    return;
                  }

                  if (playerPosHover > 1) {
                    playerPosHover = 1;
                    return;
                  }
                });
              }),
              onExit: (event) => setState(() {
                hover = false;
              }),
              child: Stack(
                children: [
                  // Progress
                  Positioned(
                    left: picked && selected == 2 ? playerPos * (width - 20) : 0,
                    top: 2.5,
                    child: Container(
                      width: picked && selected == 2 ? 10 : 0,
                      height: 10,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: !picked ? playerPos * (width - 20) + 4 : 0,
                    top: 0,
                    child: Container(
                      width: !picked ? 3 : 0,
                      height: 15,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 7,
                    child: Container(
                      width: playerPos * (width - 20),
                      height: picked && selected == 2 ? 1 : 0,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  // start limit
                  Positioned(
                    left: 0,
                    top: 5,
                    child: Container(
                      width: posxStart * (width - 10),
                      height: 5,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: blueTheme(!notifier.darkTheme),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: posxStart * (width - 20),
                    top: 2.5,
                    child: Tooltip(
                      message: getMillisToText(selected: 1),
                      verticalOffset: -35,
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
                  ),
                  // end limit
                  Positioned(
                    left: (1 - posxEnd) * (width - 10),
                    top: 5,
                    child: Row(
                      children: [
                        Container(
                          width: posxEnd * (width - 10),
                          height: 5,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: blueTheme(!notifier.darkTheme),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: (1 - posxEnd) * (width - 20),
                    top: 2.5,
                    child: Tooltip(
                      message: getMillisToText(selected: 0),
                      verticalOffset: -35,
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
                  ),
                ],
              ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                      visible: picked || hover,
                      child: Text(
                        "${getMillisToText(selected: hover && !picked ? 4 : selected)}",
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                    child: Container(),
                  ),
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
                var millis = (player.position.duration!.inMilliseconds * posxStart).toInt();
                player.seek(Duration(milliseconds: millis));

                playPauseVideo();
              },
              darkTheme: notifier.darkTheme,
              icon: widget.playPause ? Icons.pause : Icons.play_arrow,
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
                      "[ ${getMillisToText(selected: 3)} - ${getMillisToText()} ]",
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

  getMillisToText({int selected = -1}) {
    switch (selected) {
      case 0:
        return epochToTimeText((widget.player.position.duration!.inMilliseconds * (1 - posxEnd)).toInt());
      case 1:
        return epochToTimeText((widget.player.position.duration!.inMilliseconds * posxStart).toInt());
      case 2:
        return epochToTimeText((widget.player.position.duration!.inMilliseconds * playerPos).toInt());
      case 3:
        return epochToTimeText(widget.player.position.position!.inMilliseconds);
      case 4:
        return epochToTimeText((widget.player.position.duration!.inMilliseconds * playerPosHover).toInt());
      default:
        return epochToTimeText(widget.player.position.duration!.inMilliseconds);
    }
  }

  getDurationText() {
    String txt = widget.player.position.duration.toString();
    return txt.substring(0, txt.length - 3);
  }

  setSelected(double localx) {
    try {
      if (localx > (1 - posxEnd) * (width - 20) && localx < (1 - posxEnd) * (width - 20) + 20) {
        return 0;
      }

      if (localx > posxStart * (width - 20) && localx < posxStart * (width - 20) + 20) {
        return 1;
      }

      return 2;
    } catch (e) {
      return 2;
    }
  }

  bool limitSet = false;

  setPlayerPosition(double localx) {
    try {
      if (!picked) {
        picked = true;
        selected = setSelected(localx);
      }

      if (localx > width - 10) {
        setState(() {
          setCursorValue(1);

          var millis = (player.position.duration!.inMilliseconds).toInt() - 1;

          player.seek(Duration(milliseconds: millis));
          limitSet = true;
        });
        return;
      }

      if (localx > 10) {
        setState(() {
          setCursorValue((localx - 12.5) / (width - 20));

          var millis = (player.position.duration!.inMilliseconds).toInt();
          millis = getMillis(millis);

          if (millis > 0 && millis <= player.position.duration!.inMilliseconds) {
            try {
              player.seek(Duration(milliseconds: millis));
            } catch (e) {
              player.seek(Duration(milliseconds: 0));
              player.play();
            }
            limitSet = false;
            return;
          }

          if (limitSet) {
            return;
          }

          if (millis <= 0) {
            player.seek(Duration(milliseconds: 0));
            limitSet = true;
            return;
          }

          player.seek(Duration(milliseconds: player.position.duration!.inMilliseconds));
          limitSet = true;
        });
        return;
      }

      setState(() {
        playerPos = 0;
        player.seek(Duration(seconds: 0));
      });
    } catch (_) {}
  }

  setCursorValue(double value) {
    switch (selected) {
      case 0:
        if (value > 1) {
          posxEnd = 0;
          playerPos = posxStart;
          widget.setPosEnd(posxEnd);
          break;
        }

        if (value < posxStart) {
          selected = 1;
          posxEnd = 1 - posxStart;
          posxStart = value;
          widget.setPosStart(posxStart);
          return;
        }

        posxEnd = 1 - value;
        playerPos = posxStart;
        widget.setPosEnd(posxEnd);
        break;
      case 1:
        if (value < 0) {
          posxStart = 0;
          playerPos = 0;
          widget.setPosStart(posxStart);
          break;
        }

        if (value > 1 - posxEnd) {
          selected = 0;
          posxStart = 1 - posxEnd;
          posxEnd = 1 - value;
          widget.setPosEnd(posxEnd);
          return;
        }

        posxStart = value;
        playerPos = value;
        widget.setPosStart(posxStart);
        break;
      default:
        playerPos = value < 0 ? 0 : value;
    }
  }

  getMillis(int millis) {
    switch (selected) {
      case 0:
        return (millis * (1 - posxEnd)).toInt();
      case 1:
        return (millis * posxStart).toInt();
      default:
        return (millis * playerPos).toInt();
    }
  }
}

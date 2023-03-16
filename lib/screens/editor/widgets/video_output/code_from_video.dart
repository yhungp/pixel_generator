// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/button.dart';
import 'package:calculator/styles/styles.dart';
import 'package:calculator/utils/editor_code_generators/code_generators.dart';
import 'package:calculator/screens/editor/widgets/enable_brightness.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeFromVideo extends StatefulWidget {
  SettingsScreenNotifier notifier;
  List<List<String>> values;
  int rows;
  int columns;
  int matrixRows;
  int matrixColumns;
  double fps;
  Function showHideCode;

  CodeFromVideo({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.notifier,
    required this.rows,
    required this.values,
    required this.fps,
    required this.showHideCode,
  }) : super(key: key);

  @override
  State<CodeFromVideo> createState() => _CodeFromVideoState();
}

class _CodeFromVideoState extends State<CodeFromVideo> {
  late SettingsScreenNotifier notifier;
  late List<List<String>> values;
  late int rows;
  late int columns;
  late int matrixRows;
  late int matrixColumns;

  bool enableBrightnessControl = false;

  TextEditingController brightnessPin = TextEditingController();
  TextEditingController brightnessValue = TextEditingController();
  TextEditingController maxAdcValue = TextEditingController();

  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();

  @override
  void initState() {
    notifier = widget.notifier;
    values = widget.values;
    rows = widget.rows;
    columns = widget.columns;
    matrixRows = widget.matrixRows;
    matrixColumns = widget.matrixColumns;

    brightnessPin.text = "A0";
    brightnessValue.text = "255";
    maxAdcValue.text = "1023";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String outText = pixelMatrix(
      values,
      rows,
      columns,
      matrixRows,
      matrixColumns,
    );

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: blueTheme(notifier.darkTheme),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              EnableBrightness(
                showHideCode: widget.showHideCode,
                toggleSwitch: toggleSwitch,
                onPinValueChange: onPinValueChange,
                onAdcValueChange: onAdcValueChange,
                onBrightnessValueChange: onBrightnessValueChange,
                brightnessValue: brightnessValue,
                brightnessPin: brightnessPin,
                maxAdcValue: maxAdcValue,
                enableBrightnessControl: enableBrightnessControl,
                notifier: notifier,
              ),
              Expanded(child: Container()),
              EditorButton(
                backColor: Colors.transparent,
                withBorders: Colors.white,
                label: saveToFile(notifier.language),
                textOrIcon: Icon(
                  Icons.save,
                  size: 15,
                  color: Colors.white,
                ),
                func: () async {
                  String? outputFile = await FilePicker.platform.saveFile(
                    dialogTitle: selectFileToSave(notifier.language),
                    fileName: 'file.ino',
                    allowedExtensions: ['ino'],
                  );

                  if (outputFile != null) {
                    File f = File(outputFile);
                    f.writeAsString(outText);
                  }
                },
                darkTheme: !notifier.darkTheme,
              ),
              SizedBox(width: 10),
              EditorButton(
                backColor: Colors.transparent,
                withBorders: Colors.white,
                label: copyToClipBoard(notifier.language),
                darkTheme: !notifier.darkTheme,
                textOrIcon: Icon(
                  Icons.copy,
                  size: 15,
                  color: Colors.white,
                ),
                func: () async {
                  await Clipboard.setData(ClipboardData(text: outText));

                  final scaffold = ScaffoldMessenger.of(context);
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(copiedToClipBoard(notifier.language)),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  // copied successfully
                },
              ),
              SizedBox(width: 10),
              EditorButton(
                backColor: Colors.transparent,
                withBorders: Colors.white,
                label: saveToFile(notifier.language),
                darkTheme: notifier.darkTheme,
                func: () {
                  widget.showHideCode(false);
                },
                textOrIcon: Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Scrollbar(
                controller: vertical,
                thumbVisibility: true,
                trackVisibility: true,
                child: Scrollbar(
                  controller: horizontal,
                  thumbVisibility: true,
                  trackVisibility: true,
                  notificationPredicate: (notif) => notif.depth == 1,
                  child: SingleChildScrollView(
                    controller: vertical,
                    child: SingleChildScrollView(
                      controller: horizontal,
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            outText,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "SourceCodeProRegular",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onPinValueChange() {
    setState(() {});
    if (["", "3"].contains(brightnessPin.text)) {
      brightnessPin.text = "A0";
      brightnessPin.selection = TextSelection.fromPosition(TextPosition(offset: brightnessPin.text.length));
    }
  }

  onBrightnessValueChange() {
    setState(() {});
    if (brightnessValue.text == "") {
      brightnessValue.text = "255";
      brightnessValue.selection = TextSelection.fromPosition(TextPosition(offset: brightnessValue.text.length));
      setState(() {});
      return;
    }
    if (int.parse(brightnessValue.text) < 0) {
      brightnessValue.text = "0";
      brightnessValue.selection = TextSelection.fromPosition(TextPosition(offset: brightnessValue.text.length));
      setState(() {});
      return;
    }
    if (int.parse(brightnessValue.text) > 255) {
      brightnessValue.text = "255";
      brightnessValue.selection = TextSelection.fromPosition(TextPosition(offset: brightnessValue.text.length));
      setState(() {});
      return;
    }
  }

  onAdcValueChange() {
    setState(() {});
    if (maxAdcValue.text == "") {
      maxAdcValue.text = "1023";
      maxAdcValue.selection = TextSelection.fromPosition(TextPosition(offset: maxAdcValue.text.length));
      setState(() {});
      return;
    }
  }

  void toggleSwitch(bool value) {
    setState(() {
      enableBrightnessControl = !enableBrightnessControl;
    });
  }

  String pixelMatrix(List<List<String>> values, int rows, int columns, int matrixRows, int matrixColumns) {
    List<List<String>> chunks = [];
    int chunkSize = matrixColumns;
    for (var frames in values) {
      for (var i = 0; i < frames.length; i += chunkSize) {
        chunks.add(frames.sublist(i, i + chunkSize > frames.length ? frames.length : i + chunkSize));
      }
    }

    int currentValue = rows * columns * matrixRows * matrixColumns * 35;

    var addSpaces = enableBrightnessControl ? "       " : "";

    var outText = variablesAndLibraries(
      addSpaces,
      rows * columns * matrixRows * matrixColumns,
      enableBrightnessControl,
      brightnessValue,
      brightnessPin,
    );

    // add color codes
    // outText += "\nconst long pixels[] PROGMEM = {\n";
    for (int i = 0; i < values.length; i++) {
      outText += "const long pixels_$i[] PROGMEM = {\n  ${List.generate(
        rows * matrixRows * columns,
        (index) => chunks[index + rows * matrixRows * columns * i].join(", "),
      ).join(",\n  ")}\n";
      outText += "};\n\n";
    }

    int delay = 1000 ~/ widget.fps;

    outText += enableBrightnessControlLabel(maxAdcValue, delay, enableBrightnessControl);

    outText += "  for (int i = 0; i < RGB_LED_NUM; i++) {\n";
    outText += "    switch (frameCounter) {\n";

    for (int i = 0; i < values.length; i++) {
      outText += "      case $i:\n";
      outText += "        LEDs[i] = pgm_read_dword(&(pixels_$i[i]));\n";
      outText += "        break;\n";
    }

    outText += "    }\n";

    outText += frameCounterCheck(values.length, enableBrightnessControl);
    outText += setupLoopFunctions(currentValue);

    return outText;
  }
}

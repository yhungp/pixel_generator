// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/button.dart';
import 'package:calculator/screens/editor/widgets/editor_text_tield.dart';
import 'package:calculator/styles/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeFromColorsWidget extends StatefulWidget {
  CodeFromColorsWidget({
    super.key,
    required this.colors,
    required this.notifier,
    required this.showHideCode,
  });

  List<List<List<List<Color>>>> colors;
  SettingsScreenNotifier notifier;
  Function showHideCode;

  @override
  State<CodeFromColorsWidget> createState() => _CodeFromColorsWidgetState();
}

class _CodeFromColorsWidgetState extends State<CodeFromColorsWidget> {
  late List<List<List<List<Color>>>> colors;
  late SettingsScreenNotifier notifier;

  bool enableBrightnessControl = false;

  TextEditingController brightnessPin = TextEditingController();
  TextEditingController brightnessValue = TextEditingController();
  TextEditingController maxAdcValue = TextEditingController();

  ScrollController vertical = ScrollController();
  ScrollController horizontal = ScrollController();

  int columns = 0;
  int rows = 0;
  int matrixColumns = 0;
  int matrixRows = 0;

  @override
  void initState() {
    notifier = widget.notifier;
    colors = widget.colors;

    columns = colors[0].length;
    rows = colors.length;
    matrixColumns = colors[0][0][0].length;
    matrixRows = colors[0][0].length;

    brightnessPin.text = "A0";
    brightnessValue.text = "255";
    maxAdcValue.text = "1023";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String outText = getColors();

    return Expanded(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: blueTheme(notifier.darkTheme),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
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
                textOrIcon: const Icon(
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
              const SizedBox(width: 10),
              EditorButton(
                backColor: Colors.transparent,
                withBorders: Colors.white,
                label: copyToClipBoard(notifier.language),
                darkTheme: !notifier.darkTheme,
                textOrIcon: const Icon(
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
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  // copied successfully
                },
              ),
              const SizedBox(width: 10),
              EditorButton(
                backColor: Colors.transparent,
                withBorders: Colors.white,
                label: saveToFile(notifier.language),
                darkTheme: notifier.darkTheme,
                func: () {
                  widget.showHideCode(false);
                },
                textOrIcon: const Icon(
                  Icons.cancel,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
                            style: const TextStyle(
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
        ]),
      ),
    );
  }

  String getColors() {
    String outText = "";

    int currentValue = rows * columns * matrixRows * matrixColumns * 35;
    int ledCount = rows * columns * matrixRows * matrixColumns;

    var addSpaces = enableBrightnessControl ? "       " : "";

    outText = "#include <FastLED.h>\n\n";
    outText += "#define RGB_PIN       ${addSpaces}3\n";
    outText += "#define RGB_LED_NUM   $addSpaces$ledCount\n";
    outText += "#define BRIGHTNESS    $addSpaces${!enableBrightnessControl ? "255" : brightnessValue.text}\n";
    outText += "#define CHIP_SET      ${addSpaces}WS2812B\n";
    outText += "#define COLOR_CODE    ${addSpaces}GRB\n\n";
    outText += "CRGB LEDs[RGB_LED_NUM];\n\n";

    if (enableBrightnessControl) {
      outText += "int BRIGHTNESS_CONTROL_PIN = ${brightnessPin.text};\n";
      outText += "int BRIGHTNESS_PIN_VALUE   = 0;\n";
      outText += "int DELAY_COUNTER          = 0;\n";
      outText += "bool BRIGHTNESS_HAS_CHANGE = false;\n\n";
    }

    List<String> values = [];

    for (var j = 0; j < rows; j++) {
      for (var i = 0; i < columns; i++) {
        List<String> lines = [];
        bool invert = false;

        for (var r = 0; r < matrixRows; r++) {
          List<String> line = [];
          for (var c = 0; c < matrixColumns; c++) {
            String color = colors[j][i][c][r].toString();
            color = color.replaceAll("Color(", "").replaceAll(")", "");
            color = color.split("x")[1].substring(2);
            line.add("0x$color");
          }

          if (!invert) {
            lines.add(line.join(", "));
            invert = true;
            continue;
          }

          line = line.reversed.toList();
          lines.add(line.join(", "));
          invert = false;
        }
        var matrix = "const long pixels_${(j * columns + i)}[] PROGMEM = {\n";
        matrix += "  ${lines.join(",\n  ")}\n";
        matrix += "};\n";
        values.add(matrix);
      }
    }

    outText += values.join("\n");

    int delay = 50;

    outText += "\nint frameCounter = 0;\n";
    outText += "void showImage(void) {\n";
    outText += "  delay(${!enableBrightnessControl ? delay : 1});\n\n";

    if (enableBrightnessControl) {
      outText += "  DELAY_COUNTER += 1;\n\n";
      outText += "  if(DELAY_COUNTER % 20 == 0) {\n";
      outText += "    int val = map(analogRead( BRIGHTNESS_CONTROL_PIN ), 0, ${maxAdcValue.text}, 0, 255);\n";
      outText += "    if (val != BRIGHTNESS_PIN_VALUE) {\n";
      outText += "      BRIGHTNESS_PIN_VALUE = val;\n";
      outText += "      BRIGHTNESS_HAS_CHANGE = true;\n";
      outText += "      FastLED.setBrightness(BRIGHTNESS_PIN_VALUE);\n";
      outText += "    }\n";
      outText += "  }\n\n";
      outText += "  if(DELAY_COUNTER != $delay && !BRIGHTNESS_HAS_CHANGE) {\n";
      outText += "    return;\n";
      outText += "  }\n\n";
      outText += "  DELAY_COUNTER = 0;\n\n";
      // outText += "  if(!BRIGHTNESS_HAS_CHANGE) {\n";
      // outText += "    return;\n";
      // outText += "  }\n\n";
    }

    outText += "  for (int i = 0; i < RGB_LED_NUM; i++) {\n";
    // outText += "    switch (frameCounter) {\n";

    for (int i = 0; i < values.length; i++) {
      if (i < values.length - 1) {
        outText += "    if (i < ${(i + 1) * ledCount ~/ values.length}) {\n";
        outText += "      LEDs[i] = pgm_read_dword(&(pixels_$i[i${getSubstraction(i, ledCount, values.length)}]));\n";
        outText += "      continue;\n";
        outText += "    }\n\n";
        continue;
      }

      outText += "    LEDs[i] = pgm_read_dword(&(pixels_$i[i${getSubstraction(i, ledCount, values.length)}]));\n";
    }

    // outText += "    }\n";
    outText += "  }\n\n";
    outText += "  FastLED.show();\n\n";
    outText += "  frameCounter += 1;\n";
    outText += "  if (frameCounter == ${values.length}){\n";
    outText += "    frameCounter = 0;\n";
    outText += "  }\n";

    if (enableBrightnessControl) {
      outText += "\n  BRIGHTNESS_HAS_CHANGE = false;\n";
    }

    outText += "}\n\n";

    outText += "void setup() {\n";
    outText += "  Serial.begin(9600);\n";
    outText += '  Serial.println("WS2812B LEDs strip Initialize");\n';
    outText += "  FastLED.addLeds<CHIP_SET, RGB_PIN, COLOR_CODE>(LEDs, RGB_LED_NUM);\n";
    outText += "  FastLED.setBrightness(BRIGHTNESS);\n";
    outText += "  FastLED.setMaxPowerInVoltsAndMilliamps(5, $currentValue);\n";
    outText += "  FastLED.clear();\n";
    outText += "  FastLED.show();\n";
    outText += "}\n\n";

    outText += "void loop() {\n";
    outText += "  showImage();\n";
    outText += "}\n";

    return outText;
  }

  getSubstraction(int i, int ledCount, int length) {
    return (i) * ledCount ~/ length == 0 ? "" : " - ${(i) * ledCount ~/ length}";
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
}

class EnableBrightness extends StatelessWidget {
  EnableBrightness({
    Key? key,
    required this.showHideCode,
    required this.toggleSwitch,
    required this.onPinValueChange,
    required this.onAdcValueChange,
    required this.onBrightnessValueChange,
    required this.brightnessValue,
    required this.brightnessPin,
    required this.maxAdcValue,
    required this.enableBrightnessControl,
    required this.notifier,
  }) : super(key: key);

  Function showHideCode;
  Function toggleSwitch;
  Function onPinValueChange;
  Function onAdcValueChange;
  Function onBrightnessValueChange;

  TextEditingController brightnessValue;
  TextEditingController maxAdcValue;
  TextEditingController brightnessPin;

  bool enableBrightnessControl;

  SettingsScreenNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // IconButton(onPressed: () => showHideCode(), icon: Icon(Icons.cancel)),
        SizedBox(
          width: 40,
          height: 55,
          child: Switch(
            onChanged: (value) => toggleSwitch(value),
            value: enableBrightnessControl,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          addBrightnessControl(notifier.language),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(
          width: 20,
        ),
        Visibility(
          visible: enableBrightnessControl,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 1, color: Colors.white),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      const Text(
                        "Pin",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      editorTextField(brightnessPin, notifier, onPinValueChange, allowLetters: true),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Text(
                        addBrightnessValue(notifier.language),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      editorTextField(
                        brightnessValue,
                        notifier,
                        onBrightnessValueChange,
                      ),
                    ],
                  ),
                ),
                Text(
                  maxAdcValueLabel(notifier.language),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                editorTextField(
                  maxAdcValue,
                  notifier,
                  onAdcValueChange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

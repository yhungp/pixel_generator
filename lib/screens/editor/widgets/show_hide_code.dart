// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/button.dart';
import 'package:calculator/screens/editor/widgets/editor_text_tield.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowHideCodeWidget extends StatefulWidget {
  SettingsScreenNotifier notifier;
  List<String> values;
  int rows;
  int columns;
  int matrixRows;
  int matrixColumns;

  ShowHideCodeWidget({
    Key? key,
    required this.columns,
    required this.matrixColumns,
    required this.matrixRows,
    required this.notifier,
    required this.rows,
    required this.values,
  }) : super(key: key);

  @override
  State<ShowHideCodeWidget> createState() => _ShowHideCodeWidgetState();
}

class _ShowHideCodeWidgetState extends State<ShowHideCodeWidget> {
  late SettingsScreenNotifier notifier;
  late List<String> values;
  late int rows;
  late int columns;
  late int matrixRows;
  late int matrixColumns;

  bool enableBrightnessControl = false;

  TextEditingController brightnessPin = TextEditingController();
  TextEditingController brightnessValue = TextEditingController();

  @override
  void initState() {
    notifier = widget.notifier;
    values = widget.values;
    rows = widget.rows;
    columns = widget.columns;
    matrixRows = widget.matrixRows;
    matrixColumns = widget.matrixColumns;

    brightnessPin.text = "3";

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

    return Expanded(
      child: Container(
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
                enableBrightnessWidget(),
                Expanded(child: Container()),
                EditorButton(
                  label: copyToClipBoard(notifier.language),
                  func: () async {
                    await Clipboard.setData(ClipboardData(text: outText));
                    // copied successfully
                  },
                  darkTheme: !notifier.darkTheme,
                )
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var text in List.generate(outText.split("\n").length, (index) => outText.split("\n")[index]))
                        Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row enableBrightnessWidget() {
    return Row(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Switch(
            onChanged: toggleSwitch,
            value: enableBrightnessControl,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.black,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          addBrightnessControl(notifier.language),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          width: 20,
        ),
        Visibility(
          visible: enableBrightnessControl,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: buttonOnHome(!notifier.darkTheme),
            ),
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Text(
                  "Pin",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                editorTextField(
                  brightnessPin,
                  notifier,
                  onPinValueChange,
                ),
                SizedBox(
                  width: 50,
                ),
                Text(
                  addBrightnessValue(notifier.language),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                editorTextField(
                  brightnessValue,
                  notifier,
                  onBrightnessValueChange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  onPinValueChange() {
    if (brightnessPin.text == "") {
      brightnessPin.text = "3";
      brightnessPin.selection = TextSelection.fromPosition(TextPosition(offset: brightnessPin.text.length));
    }
  }

  onBrightnessValueChange() {
    if (brightnessValue.text == "") {
      brightnessValue.text = "255";
      brightnessValue.selection = TextSelection.fromPosition(TextPosition(offset: brightnessValue.text.length));
      return;
    }
    if (int.parse(brightnessValue.text) < 0) {
      brightnessValue.text = "0";
      brightnessValue.selection = TextSelection.fromPosition(TextPosition(offset: brightnessValue.text.length));
      return;
    }
    if (int.parse(brightnessValue.text) > 255) {
      brightnessValue.text = "255";
      brightnessValue.selection = TextSelection.fromPosition(TextPosition(offset: brightnessValue.text.length));
      return;
    }
  }

  void toggleSwitch(bool value) {
    setState(() {
      enableBrightnessControl = !enableBrightnessControl;
    });
  }

  String pixelMatrix(List<String> values, int rows, int columns, int matrixRows, int matrixColumns) {
    List<List<String>> chunks = [];
    int chunkSize = matrixColumns;
    for (var i = 0; i < values.length; i += chunkSize) {
      chunks.add(values.sublist(i, i + chunkSize > values.length ? values.length : i + chunkSize));
    }

    int currentValue = rows * columns * matrixRows * matrixColumns * 35;

    var outText = "#include <FastLED.h>\n\n";
    outText += "#define RGB_PIN             3\n";
    outText += "#define RGB_LED_NUM         512\n";
    outText += "#define BRIGHTNESS          255\n";
    outText += "#define CHIP_SET            WS2812B\n";
    outText += "#define COLOR_CODE          GRB\n\n";
    outText += "CRGB LEDs[RGB_LED_NUM];\n";

    // add color codes
    outText += "\nconst long pixels[] PROGMEM = {\n  ${List.generate(
      rows * matrixRows * columns,
      (index) => chunks[index].join(", "),
    ).join(",\n  ")}";
    outText += "\n};\n\n";

    outText += "void showImage(void) {\n";
    outText += "  for (int i = 0; i < RGB_LED_NUM; i++) {\n";
    outText += "    LEDs[i] = pgm_read_dword(&(pixels[i]));\n";
    outText += "  }\n";
    outText += "  FastLED.show();\n";
    outText += "  delay(200);\n";
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

    List<Text> rowsList = List.generate(
      rows * matrixRows * columns,
      (index) => Text(
        chunks[index].join(", "),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    );

    return outText;
  }
}

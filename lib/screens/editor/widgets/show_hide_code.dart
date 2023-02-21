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
  TextEditingController maxAdcValue = TextEditingController();

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
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "SourceCodeProRegular",
                          ),
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
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Pin",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                editorTextField(brightnessPin, notifier, onPinValueChange, allowLetters: true),
                SizedBox(
                  width: 30,
                ),
                Text(
                  addBrightnessValue(notifier.language),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                editorTextField(
                  brightnessValue,
                  notifier,
                  onBrightnessValueChange,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  maxAdcValueLabel(notifier.language),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                editorTextField(
                  maxAdcValue,
                  notifier,
                  onAdcValueChange,
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
      ],
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

  String pixelMatrix(List<String> values, int rows, int columns, int matrixRows, int matrixColumns) {
    List<List<String>> chunks = [];
    int chunkSize = matrixColumns;
    for (var i = 0; i < values.length; i += chunkSize) {
      chunks.add(values.sublist(i, i + chunkSize > values.length ? values.length : i + chunkSize));
    }

    int currentValue = rows * columns * matrixRows * matrixColumns * 35;

    var addSpaces = enableBrightnessControl ? "       " : "";

    var outText = "#include <FastLED.h>\n\n";
    outText += "#define RGB_PIN       ${addSpaces}3\n";
    outText += "#define RGB_LED_NUM   ${addSpaces}512\n";
    outText += "#define BRIGHTNESS    $addSpaces${!enableBrightnessControl ? "255" : brightnessValue.text}\n";
    outText += "#define CHIP_SET      ${addSpaces}WS2812B\n";
    outText += "#define COLOR_CODE    ${addSpaces}GRB\n\n";
    outText += "CRGB LEDs[RGB_LED_NUM];\n";

    if (enableBrightnessControl) {
      outText += "\nint BRIGHTNESS_CONTROL_PIN = ${brightnessPin.text};\n";
      outText += "int BRIGHTNESS_PIN_VALUE   = 0;\n";
      outText += "int DELAY_COUNTER          = 0;\n";
      outText += "bool BRIGHTNESS_HAS_CHANGE = false;\n";
    }

    // add color codes
    outText += "\nconst long pixels[] PROGMEM = {\n  ${List.generate(
      rows * matrixRows * columns,
      (index) => chunks[index].join(", "),
    ).join(",\n  ")}\n";
    outText += "};\n\n";

    outText += "void showImage(void) {\n";
    outText += "  delay(${!enableBrightnessControl ? 200 : 1});\n\n";

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
      outText += "  if(DELAY_COUNTER != 40) {\n";
      outText += "    return;\n";
      outText += "  }\n\n";
      outText += "  DELAY_COUNTER = 0;\n\n";
      outText += "  if(!BRIGHTNESS_HAS_CHANGE) {\n";
      outText += "    return;\n";
      outText += "  }\n\n";
    }

    outText += "  for (int i = 0; i < RGB_LED_NUM; i++) {\n";
    outText += "    LEDs[i] = pgm_read_dword(&(pixels[i]));\n";
    outText += "  }\n";
    outText += "  FastLED.show();\n";

    if (enableBrightnessControl) {
      outText += "  BRIGHTNESS_HAS_CHANGE = false;\n";
      outText += "  Serial.println(\"Change\");\n";
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

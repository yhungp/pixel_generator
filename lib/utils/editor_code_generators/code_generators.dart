setupLoopFunctions(currentValue) {
  String outText = "void setup() {\n";
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

frameCounterCheck(length, enableBrightnessControl) {
  String outText = "  }\n\n";
  outText += "  FastLED.show();\n\n";
  outText += "  frameCounter += 1;\n";
  outText += "  if (frameCounter == $length){\n";
  outText += "    frameCounter = 0;\n";
  outText += "  }\n";

  if (enableBrightnessControl) {
    outText += "\n  BRIGHTNESS_HAS_CHANGE = false;\n";
  }

  outText += "}\n\n";

  return outText;
}

enableBrightnessControlLabel(maxAdcValue, delay, enableBrightnessControl) {
  String outText = "\nint frameCounter = 0;\n";
  outText += "void showImage(void) {\n";
  outText += "  delay(${!enableBrightnessControl ? delay : 1});\n\n";

  if (enableBrightnessControl) {
    outText += "  DELAY_COUNTER += 1;\n\n";
    outText += "  if(DELAY_COUNTER % 20 == 0) {\n";
    outText += "    int val = map(analogRead( BRIGHTNESS_CONTROL_PIN ), 0, $maxAdcValue, 0, 255);\n";
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
  }

  return outText;
}

variablesAndLibraries(addSpaces, ledCount, enableBrightnessControl, brightnessValue, brightnessPin) {
  String outText = "#include <FastLED.h>\n\n";
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

  return outText;
}

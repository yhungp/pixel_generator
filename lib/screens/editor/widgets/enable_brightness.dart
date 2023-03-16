// ignore_for_file: must_be_immutable

import 'package:calculator/language/editor.dart';
import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/widgets/editor_text_tield.dart';
import 'package:flutter/material.dart';

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

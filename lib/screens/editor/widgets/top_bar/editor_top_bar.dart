// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:calculator/main.dart';
import 'package:calculator/screens/editor/editor.dart';
import 'package:calculator/screens/editor/widgets/scale_button.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

Row EditorTopBar(
  SettingsScreenNotifier notifier,
  Function setEditorOption,
  Function selectorBorderColor,
  double scale,
  Function downScale,
  Function upScale,
  Function saveColors,
) {
  return Row(
    children: [
      selector(notifier, setEditorOption, selectorBorderColor, saveColors),
      Expanded(child: Container()),
      viewScale(notifier, scale, downScale, upScale),
    ],
  );
}

Row selector(
  SettingsScreenNotifier notifier,
  Function setEditorOption,
  Function selectorBorderColor,
  Function saveColors,
) {
  var values = EditorOptions.values;
  return Row(
    children: [
      // black and white
      SizedBox(width: 5),

      GestureDetector(
        onTap: () => saveColors(true),
        child: Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: blueTheme(notifier.darkTheme),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(width: 5),

      SizedBox(
        height: 40,
        child: Row(
          children: [
            VerticalDivider(
              color: Colors.grey,
              thickness: 1, //thickness of divier line
            ),
          ],
        ),
      ),

      SizedBox(width: 5),

      for (var i = 0; i < values.length; i++)
        Row(
          children: [
            GestureDetector(
              onTap: () => setEditorOption(values[i]),
              child: Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                  color: blueTheme(notifier.darkTheme),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: selectorBorderColor(values[i], notifier.darkTheme),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      editorOptionsLabels[i],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
    ],
  );
}

Row viewScale(
  SettingsScreenNotifier notifier,
  double scale,
  Function downScale,
  Function upScale,
) {
  return Row(
    children: [
      for (double value in [1, 0.1, 0.01])
        Row(
          children: [
            ScaleButton(
              text: "- $value",
              darkTheme: notifier.darkTheme,
              func: downScale,
              width: 40,
              value: value,
            ),
            SizedBox(width: 5),
          ],
        ),
      Container(
        width: 100,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Text(
          "Zoom: ${scale.toStringAsFixed(2)}",
          style: TextStyle(
            color: textColorMatrixCreation(
              notifier.darkTheme,
            ),
          ),
        ),
      ),
      for (double value in [0.01, 0.1, 1])
        Row(
          children: [
            ScaleButton(
              text: "+ $value",
              darkTheme: notifier.darkTheme,
              func: upScale,
              width: 40,
              value: value,
            ),
            SizedBox(width: 5),
          ],
        ),
    ],
  );
}

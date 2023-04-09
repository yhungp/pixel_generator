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
) {
  return Row(
    children: [
      selector(notifier, setEditorOption, selectorBorderColor),
      Expanded(child: Container()),
      viewScale(notifier, scale, downScale, upScale),
    ],
  );
}

Row selector(
  SettingsScreenNotifier notifier,
  Function setEditorOption,
  Function selectorBorderColor,
) {
  var values = EditorOptions.values;
  return Row(
    children: [
      // black and white
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

      // // gray scale
      // SizedBox(width: 10),
      // GestureDetector(
      //   onTap: () => setEditorOption(EditorOptions.grayScale),
      //   child: Container(
      //     width: 50,
      //     height: 40,
      //     decoration: BoxDecoration(
      //       color: blueTheme(notifier.darkTheme),
      //       borderRadius: BorderRadius.all(Radius.circular(5)),
      //       border: Border.all(
      //         color: selectorBorderColor(EditorOptions.grayScale, notifier.darkTheme),
      //         width: 2,
      //       ),
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           "Gray",
      //           style: TextStyle(
      //             color: Colors.white,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      // // rgb
      // SizedBox(width: 10),
      // GestureDetector(
      //   onTap: () => setEditorOption(EditorOptions.rgbPicker),
      //   child: Container(
      //     width: 70,
      //     height: 40,
      //     decoration: BoxDecoration(
      //       color: blueTheme(notifier.darkTheme),
      //       borderRadius: BorderRadius.all(Radius.circular(5)),
      //       border: Border.all(
      //         color: selectorBorderColor(EditorOptions.rgbPicker, notifier.darkTheme),
      //         width: 2,
      //       ),
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Container(
      //           width: 20,
      //           height: 30,
      //           alignment: Alignment.center,
      //           decoration: BoxDecoration(
      //             color: Color.fromARGB(200, 255, 0, 0),
      //             borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
      //           ),
      //           child: Text(
      //             "R",
      //             style: TextStyle(
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //         Container(
      //           width: 20,
      //           height: 30,
      //           alignment: Alignment.center,
      //           color: Color.fromARGB(150, 0, 255, 0),
      //           child: Text(
      //             "G",
      //             style: TextStyle(
      //               color: Colors.black,
      //             ),
      //           ),
      //         ),
      //         Container(
      //           width: 20,
      //           height: 30,
      //           alignment: Alignment.center,
      //           decoration: BoxDecoration(
      //             color: Color.fromARGB(150, 0, 0, 255),
      //             borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
      //           ),
      //           child: Text(
      //             "B",
      //             style: TextStyle(
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      // // image
      // SizedBox(width: 10),
      // GestureDetector(
      //   onTap: () => setEditorOption(EditorOptions.fromImage),
      //   child: Container(
      //     width: 70,
      //     height: 40,
      //     decoration: BoxDecoration(
      //       color: blueTheme(notifier.darkTheme),
      //       borderRadius: BorderRadius.all(Radius.circular(5)),
      //       border: Border.all(
      //         color: selectorBorderColor(EditorOptions.fromImage, notifier.darkTheme),
      //         width: 2,
      //       ),
      //     ),
      //     child: Icon(
      //       Icons.image,
      //       color: Colors.white,
      //       size: 28,
      //     ),
      //   ),
      // ),

      // // black and white
      // SizedBox(width: 10),
      // GestureDetector(
      //   onTap: () => setEditorOption(EditorOptions.fromVideo),
      //   child: Container(
      //     width: 70,
      //     height: 40,
      //     decoration: BoxDecoration(
      //       color: blueTheme(notifier.darkTheme),
      //       borderRadius: BorderRadius.all(Radius.circular(5)),
      //       border: Border.all(
      //         color: selectorBorderColor(EditorOptions.fromVideo, notifier.darkTheme),
      //         width: 2,
      //       ),
      //     ),
      //     child: Icon(
      //       Icons.video_call,
      //       color: Colors.white,
      //       size: 35,
      //     ),
      //   ),
      // ),
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

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Editor extends StatefulWidget {
  bool darkTheme;
  int language;
  String filePath;
  Function setRoute;

  Editor({
    Key? key,
    required this.darkTheme,
    required this.language,
    required this.filePath,
    required this.setRoute,
  }) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsScreenNotifier>(
        builder: (context, notifier, child) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: blackTheme(notifier.darkTheme),
        padding: const EdgeInsets.all(5.0),
      );
    });
  }
}

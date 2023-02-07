// ignore_for_file: prefer_const_constructors

import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Consumer<SettingsScreenNotifier>(

                /// 1
                builder: (context, notifier, child) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      color: blackTheme(notifier.darkTheme),
                      child: Column(
                        children: [
                          SwitchListTile(
                              title: const Text('Dark Mode'),
                              value: notifier.darkTheme,
                              activeThumbImage:
                                  AssetImage("assets/white-moon.png"),
                              inactiveThumbImage:
                                  AssetImage("assets/dark-sun.png"),
                              activeColor: Colors.white,
                              secondary: const Icon(Icons.dark_mode,
                                  color: Color(0xFF642ef3)),
                              onChanged: (bool value) {
                                notifier.toggleApplicationTheme(value);

                                /// 2
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          )
        ]));
  }
}

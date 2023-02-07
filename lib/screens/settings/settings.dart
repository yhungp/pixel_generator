// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:calculator/language/settings.dart';
import 'package:calculator/main.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String dropdownvalue = 'English';
  int language = 0;

  var items = [
    'English',
    'Español',
  ];

  List<String> titles = [
    "Settings",
    "Configuraciones",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titles[language]),
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
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 18, 10, 10),
                            alignment: Alignment.center,
                            height: 70,
                            decoration: BoxDecoration(
                                color: blueTheme(notifier.darkTheme),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: SwitchListTile(
                                title: Text(
                                  settingsThemeSelector(
                                    notifier.language,
                                  ),
                                  style: TextStyle(
                                    color: buttonOnHomeTextColor(
                                        notifier.darkTheme),
                                    fontSize: 18,
                                  ),
                                ),
                                value: notifier.darkTheme,
                                activeThumbImage:
                                    AssetImage("assets/white-moon.png"),
                                inactiveThumbImage:
                                    AssetImage("assets/dark-sun.png"),
                                activeColor: Colors.white,
                                onChanged: (bool value) {
                                  notifier.toggleApplicationTheme(value);

                                  /// 2
                                }),
                          ),
                          Container(
                            height: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: blueTheme(notifier.darkTheme),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text(
                                  settingsLanguageSelector(
                                    notifier.language,
                                  ),
                                  style: TextStyle(
                                    color: buttonOnHomeTextColor(
                                        notifier.darkTheme),
                                    fontSize: 18,
                                  ),
                                ),
                                Expanded(child: Container()),
                                DropdownButton(
                                  // Initial Value
                                  value: dropdownvalue,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                      notifier.setApplicationLanguage(
                                          items.indexOf(newValue));

                                      language = items.indexOf(newValue);
                                    });
                                  },
                                ),
                                SizedBox(width: 10)
                              ],
                            ),
                          )
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

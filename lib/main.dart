// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:calculator/screens/home/home.dart';
import 'package:calculator/screens/matrix_creation/matrix_creation.dart';
import 'package:calculator/screens/media_selector/media_selector.dart';
import 'package:calculator/screens/settings/settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // // Must add this line.
  // await windowManager.ensureInitialized();

  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(800, 600),
  //   minimumSize: Size(450, 580),
  //   // center: true,
  //   backgroundColor: Colors.transparent,
  //   // skipTaskbar: false,
  //   // titleBarStyle: TitleBarStyle.hidden,
  // );

  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });
  runApp(const MyApp());
}

const List<List<String>> titles = [
  ["Home", "Home"],
  ["Matrix creation", "Creación de matrices"],
  ["Media selector", "Selector de archivo multimedia"],
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SettingsScreenNotifier(),
        builder: (context, provider) {
          return Consumer<SettingsScreenNotifier>(
              builder: (context, notifier, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              // theme: ThemeData(
              //   primarySwatch: Colors.blue,
              // ),
              theme: ThemeData(
                primarySwatch:
                    notifier.darkTheme ? Colors.blueGrey : Colors.blue,
              ),
              themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
              scrollBehavior: MyCustomScrollBehavior(),
              home: MyHomePage(
                  title: titles[notifier.currentScreen][notifier.language]),
              // home: const MyHomePage(title: 'Pixel matrix generator'),
            );
          });
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String route = "home";
  String title = "Home";
  String filePath = "";

  bool darkTheme = false;

  int language = 0;

  @override
  void initState() {
    super.initState();

    bodyContent = routes(route);
  }

  bool reload = false;
  late Widget bodyContent;

  @override
  Widget build(BuildContext context) {
    if (reload) {
      setState(() {
        reload = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Consumer<SettingsScreenNotifier>(builder: (context, notifier, child) {
            return Switch(
              value: notifier.darkTheme,
              activeThumbImage: AssetImage("assets/white-moon.png"),
              inactiveThumbImage: AssetImage("assets/dark-sun.png"),
              activeColor: Colors.white,
              onChanged: (value) {
                notifier.toggleApplicationTheme(value);
              },
            );
          }),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(child: routes(route)),
    );
  }

  void toggleSwitch(bool value) {
    setState(() {
      darkTheme = !darkTheme;
      reload = true;
      bodyContent = routes(route);
    });
  }

  setRoute(String r) {
    setState(() {
      route = r;
    });
  }

  routes(String value) {
    switch (value) {
      case "home":
        return HomePage(
            setRoute: setRoute,
            setProjectFile: setProjectFile,
            darkTheme: darkTheme,
            language: language);
      case "matrix_creation":
        return MatrixCreation(
          setRoute: setRoute,
          setProjectFile: setProjectFile,
          darkTheme: darkTheme,
          language: language,
          filePath: filePath,
        );
      case "media_selector":
        return MediaSelector(
          darkTheme: darkTheme,
          language: language,
          filePath: filePath,
        );
    }
  }

  setProjectFile(String value) {
    setState(() {
      filePath = value;
    });
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class SettingsScreenNotifier extends ChangeNotifier {
  /// 1
  bool darkTheme = true;
  int language = 0;
  int currentScreen = 0;

  /// 2
  get isDarkModeEnabled => darkTheme;
  get languageSelected => language;

  /// 3
  void toggleApplicationTheme(bool darkModeEnabled) {
    darkTheme = darkModeEnabled;
    notifyListeners();
  }

  void setApplicationLanguage(int languageSelection) {
    /// 4
    language = languageSelection;
    notifyListeners();
  }

  void setApplicationScreen(int currentScreenState) {
    /// 4
    currentScreen = currentScreenState;
    notifyListeners();
  }
}

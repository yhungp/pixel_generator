// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:calculator/screens/home/home.dart';
import 'package:calculator/screens/matrix_creation/matrix_creation.dart';
import 'package:calculator/styles/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      scrollBehavior: MyCustomScrollBehavior(),
      home: const MyHomePage(title: 'Pixel matrix generator'),
    );
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

  bool darkTheme = true;

  int language = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueTheme(darkTheme),
        title: Text(title),
      ),
      body: Container(child: routes(route)),
    );
  }

  setRoute(String r, String t) {
    setState(() {
      route = r;
      title = t;
    });
  }

  routes(String value) {
    switch (value) {
      case "home":
        return HomePage(
            title: "Home",
            setRoute: setRoute,
            darkTheme: darkTheme,
            language: language);
      case "matrix_creation":
        return const MatrixCreation(title: "Matrix creation");
    }
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

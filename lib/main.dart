import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopoly_mobile/screens/dashboard.dart';
import 'package:monopoly_mobile/screens/home.dart';
import 'package:monopoly_mobile/screens/instruct.dart';
import 'package:monopoly_mobile/screens/register.dart';
import 'package:monopoly_mobile/services/firestore.dart';
import 'firebase_options.dart';
import 'dart:convert';


const double narrowScreenWidthThreshold = 450;
const themeColor = Colors.blue;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Monopoly());
}

Function eventMessage(BuildContext context) {
    return (event) {
      final snackBar = SnackBar(
          content: Text(event, style: TextStyle(color: Theme.of(context).colorScheme.surface),
          )
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
}


class Monopoly extends StatefulWidget {
  const Monopoly({Key? key}) : super(key: key);

  @override
  State<Monopoly> createState() => _MonopolyState();
}

class _MonopolyState extends State<Monopoly> {
  bool useMaterial3 = true;
  bool useLightMode = true;
  Color currThemeColor = themeColor;
  int screenIndex = 0;
  List<dynamic> screenArgs = [];

  static DatabaseService dbService = DatabaseService();
  static Map<String, dynamic> titleDeedInfo = {};
  static Map<String, dynamic> eventInfo = {};

  late ThemeData themeData;

  @override
  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    themeData = updateThemes(currThemeColor, useMaterial3, useLightMode);

    final future = readJson();
    future.then((value) => 0);
  }

  Future<void> readJson() async {
    final String responseTitle = await rootBundle.loadString('assets/indices/TitleDeedCards.json');
    final String responseEvent = await rootBundle.loadString('assets/indices/Events.json');
    titleDeedInfo = await json.decode(responseTitle);
    eventInfo = await json.decode(responseEvent);
  }

  void changeThemeColor(Color baseColor) {
    if (currThemeColor != baseColor) {
      setState(() {
        themeData = updateThemes(baseColor, useMaterial3, useLightMode);
      });
    }
  }

  ThemeData updateThemes(Color colorSelected, bool useMaterial3, bool useLightMode) {
    currThemeColor = colorSelected;
    return ThemeData(
        colorSchemeSeed: currThemeColor,
        useMaterial3: useMaterial3,
        brightness: useLightMode ? Brightness.light : Brightness.dark);
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void handleMenuSelect(int value) {
    switch (value) {
      case 0:
        break;  // Undo
      case 1:
        dbService.clearPlayers();
        changeThemeColor(Colors.amber);
        changeScreen(2, []);
        break;
      case 2:
        break;  // End Game
      case 3:
        setState(() {
          useLightMode = !useLightMode;
          themeData = updateThemes(currThemeColor, useMaterial3, useLightMode);
        });
        break;
      default:
        break;
    }
  }

  void changeScreen(int index, List<dynamic> args) async {
    setState(() {
      screenIndex = index;
      screenArgs = args;
    });
  }

  Widget createScreenFor(int screenIndex) {
    switch (screenIndex) {
      case 0:
        return Home(dbService: dbService, navigate: changeScreen, changeTheme: changeThemeColor, eventMsg: eventMessage(context));
      case 1:
        return InstructCard(navigate: changeScreen, getTo: screenArgs[0], then: screenArgs[1], eventMsg: eventMessage(context));
      case 2:
        return Register(dbService: dbService, navigate: changeScreen, changeTheme: changeThemeColor, eventMessage: eventMessage(context));
      case 3:
        return Dashboard(dbService: dbService, navigate: changeScreen, changeTheme: changeThemeColor, eventMsg: eventMessage(context));
      default:
        return Register(dbService: dbService, navigate: changeScreen, changeTheme: changeThemeColor, eventMessage: eventMessage(context));
    }
  }

  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Monopoly ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            Text(
              'Banking Unit',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 0,
                child: Wrap(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.undo_rounded),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Undo (Disabled)")
                    )
                  ],
                )
            ),
            PopupMenuItem(
                value: 1,
                child: Wrap(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.add_rounded),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("New Game")
                    )
                  ],
                )
            ),
            PopupMenuItem(
                value: 2,
                child: Wrap(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.stop_rounded),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("End Game")
                    )
                  ],
                )
            ),
            PopupMenuItem(
              value: 3,
              child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    useLightMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Switch to ${useLightMode ? 'dark' : 'light'} mode")
                ),
              ],
              )
            ),
          ],
          onSelected: handleMenuSelect,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monopoly - Banking Unit',
      themeMode: useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: themeData,
      home: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          appBar: createAppBar(),
          body: Row(children: <Widget>[
            createScreenFor(screenIndex),
          ]),
        );
      }),
    );
  }
}

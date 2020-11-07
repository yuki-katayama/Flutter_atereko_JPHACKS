import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttervoicegame/page/input_name_page.dart';
import 'package:fluttervoicegame/page/profile_page.dart';
import 'package:fluttervoicegame/page/start_page.dart';
import 'package:fluttervoicegame/widget/root.dart';
import 'package:fluttervoicegame/page/home_page.dart';
import 'page/home_page.dart';
import 'page/play_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // default
        // primarySwatch: Colors.cyan,
        primaryColor: Colors.blueGrey[600],
        accentColor: Colors.blueGrey[600],
      ),
      home: StartPage(),
      routes: <String,WidgetBuilder>{
        '/home': (BuildContext context) => MyHomePage(),
        '/profile': (BuildContext context) => ProfilePage(),
        '/start': (BuildContext context) => StartPage(),
        '/bottom': (BuildContext context) => BottomNavgationBarPage(),
        '/name': (BuildContext context) => InputName(),
      },
    );
  }
}
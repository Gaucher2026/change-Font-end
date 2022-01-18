import 'package:echange/views/Pages/connexion.dart';
import 'package:echange/views/Pages/index.dart';
import 'package:echange/views/Pages/inscription.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.black87,
        scaffoldBackgroundColor: Colors.white60,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/inscription',
      routes: <String, WidgetBuilder>{
        '/connexion': (context) => Login(),
        '/inscription': (context) => Inscription(),
        '/index': (context) => Index()
      },
    );
  }
}

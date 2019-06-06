import 'package:flutter/material.dart';
import 'package:music/home.dart';
import 'package:music/splash.dart';
import 'permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: TextTheme(body1: TextStyle(color: Colors.black)),
      ),
      home: GetPermissions(),
    );
  }
}

import 'package:flutter/material.dart';
import 'permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: TextTheme(body1: TextStyle(color: Colors.black)),
      ),
      home: GetPermissions(),
    );
  }
}

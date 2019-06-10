import 'package:Tunein/root.dart';
import 'package:Tunein/store/locator.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() async {
  final r =
      await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
  print("permission is " + r.toString());
  setupLocator();

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}

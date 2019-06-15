import 'package:Tunein/root.dart';
import 'package:Tunein/services/locator.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() async {
  await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
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

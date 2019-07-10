import 'package:Tunein/plugins/nano.dart';
import 'package:Tunein/root.dart';
import 'package:Tunein/services/locator.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';

Nano nano = Nano();

void main() async {
  await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
  setupLocator();

  // List<Tune> tunes = await nano.fetchSongs();

  // print(tunes.length);
  // print(tunes[2].albumArt);

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

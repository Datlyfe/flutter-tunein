import 'package:Tunein/root.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() async {
  await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
  setupLocator();
  await loadFiles();
  runApp(new MyApp());
}

Future<void> loadFiles() async {
  final musicService = locator<MusicService>();
  final data = await musicService.retrieveFiles();
  if (data.length == 0) {
    await musicService.fetchSongs();
    musicService.saveFiles();
    musicService.retrieveFavorites();
  } else {
    musicService.retrieveFavorites();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}
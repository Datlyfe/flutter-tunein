import 'package:Tunein/components/shuffle.dart';
import 'package:Tunein/globals.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: MyTheme.darkBlack,
      child: Column(
        children: <Widget>[PageHeader("Favorites", "0 Tracks", 0xeaaf)],
      ),
    );
  }
}

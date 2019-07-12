import 'package:Tunein/globals.dart';
import 'package:flutter/material.dart';

class Artists extends StatefulWidget {
  Artists({Key key}) : super(key: key);

  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.darkBlack,
      child: Center(
        child: Text(
          "ARTSITS",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

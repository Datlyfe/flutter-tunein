import 'package:flutter/material.dart';

import '../../globals.dart';

class Albums extends StatefulWidget {
  Albums({Key key}) : super(key: key);

  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.darkBlack,
      child: Center(
        child: Text(
          "ALBUMS",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Playlists extends StatefulWidget {
  Playlists({Key key}) : super(key: key);

  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlists> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "PLAYLISTS",
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:Tunein/plugins/nano.dart';
import 'package:flutter/material.dart';

class GridCell extends StatelessWidget {
  const GridCell(this.song);
  @required
  final Tune song;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            song.albumArt==null?Image.asset("images/cover.png"):Image.file(File(song.albumArt)),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                color: new Color(song.colors[0]),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        song.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: new Color(song.colors[1]).withOpacity(.7),
                        ),
                      ),
                    ),
                    Text(
                      song.artist,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: new Color(song.colors[1]).withOpacity(.7)
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

import 'dart:ui';
import 'dart:ui';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music/blocs/global.dart';
import 'package:music/models/playerstate.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NowPlayingScreen extends StatelessWidget {
  BehaviorSubject<PaletteGenerator> _palette;

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    final double _radius = 25.0;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _albumArtSize = _screenHeight / 1.9;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _albumArtSize + 50,
            child: Stack(
              children: <Widget>[
                StreamBuilder<MapEntry<PlayerState, Song>>(
                  stream: _globalBloc.musicPlayerBloc.playerState$,
                  builder: (BuildContext context,
                      AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.value.albumArt == null) {
                      return Text("No album art");
                    }

                    final Song _currentSong = snapshot.data.value;

                    // _generatePalette(context, _currentSong.albumArt)
                    //     .then((data) {
                    //   _palette.add(data);
                    // });

                    return StreamBuilder(
                      stream: _palette,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        // print(snapshot.hasData);
                        // if (!snapshot.hasData) {
                        //   return Text("No album art");
                        // }
                        return Container(
                          child: FadeInImage(
                            fadeInDuration: Duration(milliseconds: 50),
                            fadeOutDuration: Duration(milliseconds: 50),
                            image: AssetImage(_currentSong.albumArt),
                            placeholder: AssetImage("images/note.png"),
                            width: _albumArtSize,
                            height: _albumArtSize,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getDuration(Song _song) {
    final double _temp = _song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }

  Future<PaletteGenerator> _generatePalette(context, String imagePath) async {
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(AssetImage(imagePath),
            maximumColorCount: 10);

    return _paletteGenerator;
  }
}

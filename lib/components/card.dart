import 'dart:io';

import 'package:Tunein/plugins/nano.dart';
import 'package:Tunein/services/locator.dart';
import 'package:Tunein/services/musicService.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/models/playerstate.dart';

class MyCard extends StatelessWidget {
  final Tune _song;
  final musicService = locator<MusicService>();

  MyCard({Key key, @required Tune song})
      : _song = song,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: musicService.playerState$,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<PlayerState, Tune>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final Tune _currentSong = snapshot.data.value;
        final bool _isSelectedSong = _song == _currentSong;
        final _textColor = _isSelectedSong ? Colors.white : Colors.white54;
        final _fontWeight = _isSelectedSong ? FontWeight.w900 : FontWeight.w400;

        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: SizedBox(
                        height: 62,
                        width: 62,
                        child: FadeInImage(
                          placeholder: AssetImage('images/track.png'),
                          fadeInDuration: Duration(milliseconds: 200),
                          fadeOutDuration: Duration(milliseconds: 100),
                          image: _song.albumArt != null
                              ? FileImage(
                                  new File(_song.albumArt),
                                )
                              : AssetImage('images/track.png'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              (_song.title == null)
                                  ? "Unknon Title"
                                  : _song.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: _fontWeight,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            (_song.artist == null)
                                ? "Unknown Artist"
                                : _song.artist,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: _fontWeight,
                              color: _textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon: Icon(
                      IconData(0xea7c, fontFamily: 'boxicons'),
                      size: 22,
                    ),
                    onPressed: () {},
                    color: Colors.white30,
                  )),
            ],
          ),
        );
      },
    );
  }
}

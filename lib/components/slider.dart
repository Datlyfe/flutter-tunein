import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:Tunein/blocs/global.dart';
import 'package:Tunein/globals.dart';
import 'package:Tunein/models/playerstate.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder<MapEntry<Duration, MapEntry<PlayerState, Song>>>(
      stream: Observable.combineLatest2(_globalBloc.musicPlayerBloc.position$,
          _globalBloc.musicPlayerBloc.playerState$, (a, b) => MapEntry(a, b)),
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<Duration, MapEntry<PlayerState, Song>>>
              snapshot) {
        if (!snapshot.hasData) {
          return Slider(
            value: 0,
            onChanged: (double value) => null,
            activeColor: MyTheme.darkRed,
            inactiveColor: Colors.white24,
          );
        }
        if (snapshot.data.value.key == PlayerState.stopped) {
          return Slider(
            value: 0,
            onChanged: (double value) => null,
            activeColor: MyTheme.darkRed,
            inactiveColor: Colors.white24,
          );
        }
        final Duration _currentDuration = snapshot.data.key;
        final Song _currentSong = snapshot.data.value.value;
        final int _millseconds = _currentDuration.inMilliseconds;
        final int _songDurationInMilliseconds = _currentSong.duration;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                parseDuration(_currentDuration.inMilliseconds),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: _songDurationInMilliseconds.toDouble(),
                  value: _songDurationInMilliseconds > _millseconds
                      ? _millseconds.toDouble()
                      : _songDurationInMilliseconds.toDouble(),
                  onChangeStart: (double value) =>
                      _globalBloc.musicPlayerBloc.invertSeekingState(),
                  onChanged: (double value) {
                    final Duration _duration = Duration(
                      milliseconds: value.toInt(),
                    );
                    _globalBloc.musicPlayerBloc.updatePosition(_duration);
                  },
                  onChangeEnd: (double value) {
                    _globalBloc.musicPlayerBloc.invertSeekingState();
                    _globalBloc.musicPlayerBloc.audioSeek(value / 1000);
                  },
                  activeColor: MyTheme.darkRed.withOpacity(0.7),
                  inactiveColor: Colors.white24,
                ),
              ),
              Text(
                parseDuration(_songDurationInMilliseconds),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }

  String parseDuration(x) {
    final double _temp = x / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }
}

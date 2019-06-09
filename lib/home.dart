import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'blocs/global.dart';
import 'components/shuffle.dart';
import 'globals.dart';
import 'components/card.dart';
import 'models/playerstate.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc store = Provider.of<GlobalBloc>(context);
    return Container(
      alignment: Alignment.center,
      color: MyTheme.darkBlack,
      child: Column(
        children: <Widget>[
          SuffleWidget(),
          Expanded(
            child: StreamBuilder(
              stream: store.musicPlayerBloc.songs$,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                final _songs = snapshot.data;
                _songs.sort((a, b) {
                  return a.title.toLowerCase().compareTo(b.title.toLowerCase());
                });
                return Theme(
                  data:
                      Theme.of(context).copyWith(accentColor: MyTheme.darkRed),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemExtent: 70,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _songs.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<MapEntry<PlayerState, Song>>(
                        stream: store.musicPlayerBloc.playerState$,
                        builder: (BuildContext context,
                            AsyncSnapshot<MapEntry<PlayerState, Song>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          final PlayerState _state = snapshot.data.key;
                          final Song _currentSong = snapshot.data.value;
                          final bool _isSelectedSong =
                              _currentSong == _songs[index];
                          return GestureDetector(
                            onTap: () {
                              store.musicPlayerBloc.updatePlaylist(_songs);
                              switch (_state) {
                                case PlayerState.playing:
                                  if (_isSelectedSong) {
                                    store.musicPlayerBloc
                                        .pauseMusic(_currentSong);
                                  } else {
                                    store.musicPlayerBloc.stopMusic();
                                    store.musicPlayerBloc.playMusic(
                                      _songs[index],
                                    );
                                  }
                                  break;
                                case PlayerState.paused:
                                  if (_isSelectedSong) {
                                    store.musicPlayerBloc
                                        .playMusic(_songs[index]);
                                  } else {
                                    store.musicPlayerBloc.stopMusic();
                                    store.musicPlayerBloc.playMusic(
                                      _songs[index],
                                    );
                                  }
                                  break;
                                case PlayerState.stopped:
                                  store.musicPlayerBloc
                                      .playMusic(_songs[index]);
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: MyCard(
                              song: _songs[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

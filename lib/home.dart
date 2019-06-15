import 'package:Tunein/store/locator.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'blocs/music_player.dart';
import 'components/shuffle.dart';
import 'globals.dart';
import 'components/card.dart';
import 'models/playback.dart';
import 'models/playerstate.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final musicService = locator<MusicService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 85),
      alignment: Alignment.center,
      color: MyTheme.darkBlack,
      child: Column(
        children: <Widget>[
          PageHeader("Library", "All Tracks",
              MapEntry(IconData(0xeccd, fontFamily: 'boxicons'), Colors.white)),
          Expanded(
            child: StreamBuilder(
              stream: musicService.songs$,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                final _songs = snapshot.data;
                _songs.sort((a, b) {
                  return a.title.toLowerCase().compareTo(b.title.toLowerCase());
                });
                return ListView.builder(
                  shrinkWrap: true,
                  itemExtent: 62,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _songs.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<MapEntry<PlayerState, Song>>(
                      stream: musicService.playerState$,
                      builder: (BuildContext context,
                          AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        final PlayerState _state = snapshot.data.key;
                        final Song _currentSong = snapshot.data.value;
                        final bool _isSelectedSong =
                            _currentSong == _songs[index];
                        return GestureDetector(
                          onTap: () {
                            musicService.updatePlaylist(_songs);
                            switch (_state) {
                              case PlayerState.playing:
                                if (_isSelectedSong) {
                                  musicService.pauseMusic(_currentSong);
                                } else {
                                  musicService.stopMusic();
                                  musicService.playMusic(
                                    _songs[index],
                                  );
                                }
                                break;
                              case PlayerState.paused:
                                if (_isSelectedSong) {
                                  musicService.playMusic(_songs[index]);
                                } else {
                                  musicService.stopMusic();
                                  musicService.playMusic(
                                    _songs[index],
                                  );
                                }
                                break;
                              case PlayerState.stopped:
                                musicService.playMusic(_songs[index]);
                                break;
                              default:
                                break;
                            }
                          },
                          child: MyCard(
                            song: _songs[index],
                          ),
                          // child: Text(_songs[index].title,style:TextStyle(color: Colors.white) ,),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

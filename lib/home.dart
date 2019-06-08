import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music/components/bottomBar.dart';
import 'package:music/components/playing.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'blocs/global.dart';
import 'components/appbar.dart';
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
    return Scaffold(
      appBar: new MyAppBar(),
      bottomNavigationBar: Bottombar(),
      body: SlidingUpPanel(
        panel: NowPlayingScreen(),
        body: Container(
          alignment: Alignment.center,
          color: MyTheme.darkBlack,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      cursorColor: Colors.white,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.white30,
                          ),
                          icon: Icon(
                            IconData(0xeb2e, fontFamily: "Boxicons"),
                            color: Colors.white30,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          hintText: 'Track, Album, Artsit'),
                    ),
                    SizedBox(
                      height: 30.0,
                      child: Divider(
                        height: 2.0,
                        color: MyTheme.bgdivider,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: store.musicPlayerBloc.songs$,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Song>> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    final _songs = snapshot.data;
                    _songs.sort((a, b) {
                      return a.title
                          .toLowerCase()
                          .compareTo(b.title.toLowerCase());
                    });
                    return Theme(
                      data: Theme.of(context)
                          .copyWith(accentColor: MyTheme.darkRed),
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
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    GlobalBloc store = Provider.of(context);
    List<Song> _songs = store.musicPlayerBloc.songs$.value;
    List<Song> dummySearchList = List<Song>();
    if (query.isNotEmpty) {
      _songs.forEach((item) {
        if (item.title.contains(query)) {
          dummySearchList.add(item);
        }
      });
      store.musicPlayerBloc.songs$.add(dummySearchList);
      return;
    }
  }
}

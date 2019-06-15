
import 'package:flute_music_player/flute_music_player.dart';

class SongPlus extends Song {
  Song song;
  List<int> colors;

  SongPlus(this.song, this.colors)
      : super(song.id, song.artist, song.title, song.album, song.albumId,
            song.duration, song.uri, song.albumArt);

  SongPlus.fromMap(Map m) : super.fromMap(m) {
    
    colors = m["colors"].cast<int>();
  }
}

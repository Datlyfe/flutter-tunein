
import 'package:music/blocs/music_player.dart';
import 'package:music/blocs/permissions.dart';

class GlobalBloc {
  MusicPlayerBloc _musicPlayerBloc;
  MusicPlayerBloc get musicPlayerBloc => _musicPlayerBloc;

  GlobalBloc() {
    _musicPlayerBloc = MusicPlayerBloc();
  }

  void dispose() {
    _musicPlayerBloc.dispose();
  }
}

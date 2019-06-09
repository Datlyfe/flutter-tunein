
import 'package:Tunein/blocs/music_player.dart';
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

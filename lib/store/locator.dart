import 'package:Tunein/blocs/music_player.dart';
import 'package:get_it/get_it.dart';

GetIt locator = new GetIt();

void setupLocator() {
  locator.registerSingleton(MusicService());
}

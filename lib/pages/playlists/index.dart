import 'package:Tunein/components/pagenavheader.dart';
import 'package:Tunein/pages/playlists/favorites.dart';
import 'package:Tunein/pages/playlists/playlists.dart';
import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:flutter/material.dart';

class PlaylistsPage extends StatelessWidget {
  final layoutService = locator<LayoutService>();
  PlaylistsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: MediaQuery.of(context).padding,
        ),
        PageNavHeader(
          pageIndex: 1,
        ),
        Expanded(
            child: PageView(
          controller: layoutService.pageServices[1].pageViewController,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            Playlists(),
            Favorites(),
          ],
        )),
      ],
    );
  }
}

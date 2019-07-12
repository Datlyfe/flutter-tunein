import 'package:Tunein/components/pagenavheader.dart';
import 'package:Tunein/pages/collection/favorites.page.dart';
import 'package:Tunein/pages/collection/playlists.page.dart';
import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatelessWidget {
  CollectionPage({Key key}) : super(key: key);
  final layoutService = locator<LayoutService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PageNavHeader(
          pageIndex: 1,
        ),
        Flexible(
          child: PageView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: layoutService.pageServices[1].pageViewController,
            children: [
              PlaylistsPage(),
              FavoritesPage(),
            ],
          ),
        )
      ],
    );
  }
}

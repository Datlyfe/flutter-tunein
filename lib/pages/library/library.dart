import 'package:Tunein/components/pagenavheader.dart';
import 'package:Tunein/services/layout.dart';
import 'package:Tunein/services/locator.dart';
import 'package:flutter/material.dart';

import 'Tracks.dart';
import 'albums.dart';
import 'artists.dart';

class LibraryPage extends StatelessWidget {
  final layoutService = locator<LayoutService>();
  LibraryPage({Key key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: MediaQuery.of(context).padding,
        ),
        PageNavHeader(
          pageIndex: 0,
        ),
        Expanded(
            child: PageView(
          controller: layoutService.pageServices[0].pageViewController,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            Tracks(),
            Artists(),
            Albums(),
          ],
        )),
      ],
    );
  }
}

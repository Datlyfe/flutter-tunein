import 'package:flutter/material.dart';
import '../globals.dart';
import '../musicplayer.dart' as musicplayer;

class MyCard extends StatelessWidget {
  final image;
  final String artist;
  final String title;

  MyCard(this.title, this.artist, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: MyTheme.bgBottomBar,
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 13),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(10.0),
                    child: FadeInImage(
                      fadeInDuration: Duration(milliseconds: 200),
                      fadeOutDuration: Duration(milliseconds: 200),
                      image: AssetImage(this.image),
                      placeholder: AssetImage("images/placeholder.png"),
                      width: 45,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          this.artist,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: MyTheme.grey500,
                          ),
                        ),
                      ),
                      Text(
                        this.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: MyTheme.darkRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              IconData(0xea7a, fontFamily: 'boxicons'),
              color: MyTheme.darkRed,
            ),
          ),
        ],
      ),
    );
  }
}

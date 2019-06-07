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
    return Material(
      animationDuration: Duration(milliseconds: 1000),
      color: MyTheme.darkBlack,
      child: InkWell(
        onTap: () {
          
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(1.0),
                        child: FadeInImage(
                          fadeInDuration: Duration(milliseconds: 50),
                          fadeOutDuration: Duration(milliseconds: 50),
                          image: AssetImage(this.image),
                          placeholder: AssetImage("images/note.png"),
                          fit: BoxFit.fitHeight,
                        ),
                        // child: Text("image"),
                        // child: Image.asset(this.image),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              (this.title != null) ? this.title : "Unknown",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: MyTheme.grey700,
                              ),
                            ),
                          ),
                          Text(
                            (this.artist != null) ? this.title : "Unknown Artist",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  IconData(0xea7c, fontFamily: 'Boxicons'),
                  // size: 25,
                  color: Colors.white54,
                ),
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

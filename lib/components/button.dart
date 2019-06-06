import 'package:flutter/material.dart';
import '../globals.dart';

class MyFlatButton extends StatelessWidget {
  final icon;
  final String text;
  bool custom;

  MyFlatButton(this.icon, this.text, [this.custom = true]);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      // color: grey300,
      color: MyTheme.bgBottomBar,
      // highlightColor: grey500,
      splashColor: MyTheme.darkRed,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(6.0),
      ),
      onPressed: () => {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              this.text,
              style: TextStyle(
                  color: MyTheme.grey500, fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: this.custom
                  ? Icon(
                      IconData(this.icon, fontFamily: 'Boxicons'),
                      size: 18,
                      color: MyTheme.darkRed,
                    )
                  : Icon(
                      this.icon,
                      size: 18,
                      color: MyTheme.darkRed,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

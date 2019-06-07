import 'package:flutter/material.dart';
import '../globals.dart';

class MyFlatButton extends StatelessWidget {
  final icon;
  final String text;
  bool custom;
  var action;

  MyFlatButton(this.icon, this.text, this.action, [this.custom = true]);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: MyTheme.bgBottomBar,
      splashColor: MyTheme.darkRed,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(6.0),
      ),
      onPressed: this.action,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    this.text,
                    style: TextStyle(
                        color: MyTheme.grey500, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: this.custom
                  ? Icon(
                      IconData(this.icon, fontFamily: 'Boxicons'),
                      size: 18,
                      color: Colors.white54,
                    )
                  : Icon(
                      this.icon,
                      size: 18,
                      color: Colors.white54,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

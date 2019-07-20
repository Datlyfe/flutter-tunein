import 'dart:ui';

class MyTheme {
  static final darkRed = Color(0xffff245a);
  static final darkBlack = Color(0xff111111);
  static final grey300 = Color(0xfff6f8fb);
  static final grey500 = Color(0xffdee5ec);
  static final grey700 = Color(0xfff5f5f5);
  static final darkgrey = Color(0xffa3acbd);
  static final bgBottomBar = Color(0xff1e1e1e);
  static final bgdivider = Color(0xff2c2c2c);
}

class MyUtils {
  static String getArtists(artists) {
    if(artists == null) return "Unknow Artist";
    return artists.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }
}

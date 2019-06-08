import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/home.dart';
import 'package:provider/provider.dart';

import 'blocs/global.dart';
import 'globals.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  bool loading = false;

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  void setOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void init(GlobalBloc store) {
    store.musicPlayerBloc.retrieveFiles().then((data) {
      print(data.length);
      if (data == null || data.length == 0) {
        this.loading = true;
        store.musicPlayerBloc.fetchSongs().then((_) {
          store.musicPlayerBloc.saveFiles();
          store.musicPlayerBloc.retrieveFavorites();
          onDoneLoading();
        });
      } else {
        onDoneLoading();
      }
    });
  }

  @override
  void initState() {
    setOrientation();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final GlobalBloc store = Provider.of<GlobalBloc>(context);
    Future.delayed(
      Duration(milliseconds: 1000),
      () {
        init(store);
      },
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyTheme.darkBlack,
        child: Center(
          child: Container(
              margin: EdgeInsets.all(20.0),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      "images/logo5.png",
                      width: 175,
                    ),
                    Text(
                      "Tunein",
                      style: TextStyle(
                        fontFamily: 'pacifico',
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                      child: this.loading
                          ? Column(
                              children: <Widget>[
                                SpinKitFadingCircle(
                                  color: MyTheme.darkRed,
                                  size: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Text(
                                    "Reading files...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            )
                          : Text(""),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

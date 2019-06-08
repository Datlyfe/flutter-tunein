import 'package:flutter/material.dart';
import 'package:music/globals.dart';
import 'package:music/home.dart';
import 'package:provider/provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

import 'blocs/global.dart';

class GetPermissions extends StatefulWidget {
  @override
  GetPermissionsState createState() => GetPermissionsState();
}

class GetPermissionsState extends State<GetPermissions> {
  Permission permission = Permission.ReadExternalStorage;

  void init(GlobalBloc store) async {
    final r = await SimplePermissions.requestPermission(permission);
    print("permission is " + r.toString());

    store.musicPlayerBloc.retrieveFiles().then((data) {
      print(data.length);
      if (data == null || data.length == 0) {
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

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  void didChangeDependencies() {
    final GlobalBloc store = Provider.of<GlobalBloc>(context);
    Future.delayed(
      Duration(milliseconds: 0),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Image.asset(
                    //   "images/logo5.png",
                    //   width: 175,
                    // ),
                    Text(
                      "Tunein",
                      style: TextStyle(
                        fontFamily: 'pacifico',
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

import 'package:busapp/Screens/homepage.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:busapp/Widgets/zeroHeightAppbar.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  Future goToNextPage;

  gotoHome() async {
    await Future.delayed(
      Duration(milliseconds: 1500),
    );
    return true;
  }

  initState() {
    goToNextPage = gotoHome();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: zeroHeightAppbar(context, color: primaryColor),
      body: FutureBuilder(
        future: goToNextPage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          }
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor,
                  Color(0xff444477),
                ],
              ),
            ),
            child: Center(
              child: Image(
                image: AssetImage("assets/pngicon.png"),
                color: Colors.white,
                width: 100,
              ),
            ),
          );
        },
      ),
    );
  }
}

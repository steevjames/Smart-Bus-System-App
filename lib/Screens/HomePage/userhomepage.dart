import 'dart:convert';
import 'package:busapp/Screens/UserRegistration/login.dart';
import 'package:busapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  var userData;
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('userData');
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  initState() {
    userData = getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Welcome"),
            FutureBuilder(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var userData = jsonDecode(snapshot.data);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Text(
                          userData.toString(),
                        ),
                        SizedBox(height: 50),
                        QrImage(
                          data: userData.toString(),
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            logout();
                          },
                          child: Text("Logout"),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

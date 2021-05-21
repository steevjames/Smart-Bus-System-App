import 'dart:convert';
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
    Navigator.pushReplacement(
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
                  print(userData);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Text(
                          userData.toString(),
                        ),
                        Image.network(
                          userData["picture"],
                          width: 100,
                        ),
                        Text(userData["userDetails"]["firstName"].toString() +
                            ' ' +
                            userData["userDetails"]["lastName"].toString()),
                        Text("Account balance: " +
                            userData["userDetails"]["accBalance"].toString()),
                        Text(userData["userDetails"]["phoneNo"].toString()),
                        Text(userData["userDetails"]["email"].toString()),
                        SizedBox(height: 50),
                        QrImage(
                          data: userData.toString(),
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("View travel history"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Add balance"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Refresh QR"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Update Profile"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Report Complaint"),
                        ),
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

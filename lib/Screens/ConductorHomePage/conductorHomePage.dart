import 'dart:convert';
import 'package:busapp/Screens/ConductorHomePage/Components/qrCodeScan.dart';
import 'package:busapp/Screens/homepage.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConductorHomePage extends StatefulWidget {
  @override
  _ConductorHomePageState createState() => _ConductorHomePageState();
}

class _ConductorHomePageState extends State<ConductorHomePage> {
  var conductorData;
  getConductorData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('coductorData');
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('coductorData');
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  scanQR() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrcodeScan(),
      ),
    ).then((value) {
      if (value == null) return;
      alertDialog(text: value.toString(), context: context);
    });
  }

  initState() {
    conductorData = getConductorData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conductor Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Welcome"),
            FutureBuilder(
              future: conductorData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var userData = jsonDecode(snapshot.data);
                  print(userData["conductorDetails"]["phoneNo"]);
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
                        Text(userData["conductorDetails"]["firstName"] +
                            " " +
                            userData["conductorDetails"]["lastName"]),
                        Text(userData["conductorDetails"]["email"].toString()),
                        Text(
                          userData["conductorDetails"]["phoneNo"],
                        ),
                        SizedBox(height: 50),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            scanQR();
                          },
                          child: Text("Scan QR"),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            alertDialog(text: "Coming soon", context: context);
                          },
                          child: Text("Start Trip"),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            alertDialog(text: "Coming soon", context: context);
                          },
                          child: Text("Trip History"),
                        ),
                        SizedBox(height: 30),
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

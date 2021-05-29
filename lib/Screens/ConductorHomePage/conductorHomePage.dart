import 'dart:convert';
import 'package:busapp/Screens/ConductorHomePage/Components/qrCodeScan.dart';
import 'package:busapp/Screens/homepage.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/homeOptionCard.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConductorHomePage extends StatefulWidget {
  @override
  _ConductorHomePageState createState() => _ConductorHomePageState();
}

class _ConductorHomePageState extends State<ConductorHomePage> {
  var conductorData;
  bool isQrLoading = false;

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

  verifyQR(String data) async {
    setState(() {
      isQrLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      isQrLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      snackBar(
        "QR Code Successfully verified",
      ),
    );
  }

  scanQR() async {
    var value = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => QrcodeScan(),
      ),
    );
    if (value == null) return;
    verifyQR(value);
  }

  initState() {
    conductorData = getConductorData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: conductorData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = jsonDecode(snapshot.data);
            print(userData["conductorDetails"]["phoneNo"]);
            return DefTemplate(
              showBackButton: true,
              topChildren: [
                SizedBox(height: 0),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * .1),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(userData["picture"]),
                      radius: 30,
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey,",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          userData["conductorDetails"]["firstName"].toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
              bottomChildren: [
                // Text(
                //   userData.toString(),
                // ),
                DetailTile(
                    icon: Icons.account_circle,
                    text: userData["conductorDetails"]["firstName"] +
                        " " +
                        userData["conductorDetails"]["lastName"]),
                DetailTile(
                    icon: Icons.email,
                    text: userData["conductorDetails"]["email"].toString()),
                DetailTile(
                  icon: Icons.phone,
                  text: userData["conductorDetails"]["phoneNo"],
                ),
                SizedBox(height: 20),
                isQrLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      )
                    : HomeOptionCard(
                        icon: Icons.qr_code,
                        onPressed: () {
                          scanQR();
                        },
                        text: "Scan QR",
                      ),
                HomeOptionCard(
                  icon: Icons.travel_explore,
                  onPressed: () {
                    alertDialog(text: "Coming soon", context: context);
                  },
                  text: "Start Trip",
                ),
                HomeOptionCard(
                  icon: Icons.history,
                  onPressed: () {
                    alertDialog(text: "Coming soon", context: context);
                  },
                  text: "Trip History",
                ),
                HomeOptionCard(
                  icon: Icons.logout,
                  onPressed: () {
                    logout();
                  },
                  text: "Logout",
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  final IconData icon;
  final String text;
  DetailTile({this.icon, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
      child: Row(
        children: [
          Icon(
            icon,
            color: lightBlack,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: lightBlack,
              ),
            ),
          )
        ],
      ),
    );
  }
}

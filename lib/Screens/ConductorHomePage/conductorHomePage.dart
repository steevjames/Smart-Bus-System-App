import 'dart:convert';
import 'package:busapp/Screens/ConductorHomePage/Components/qrCodeScan.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/homeOptionCard.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:busapp/baseUrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConductorHomePage extends StatefulWidget {
  @override
  _ConductorHomePageState createState() => _ConductorHomePageState();
}

class _ConductorHomePageState extends State<ConductorHomePage> {
  var conductorData;
  bool isQrLoading = false;

  getConductorData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.get('coductorData'));
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('coductorData');
    Navigator.pop(context);
  }

  verifyQR(String data) async {
    try {
      var qrData = jsonDecode(data);
      print(qrData);
      setState(() {
        isQrLoading = true;
      });
      var conductorData = await getConductorData();

      var res = await http.post(
        Uri.parse(baseUrl + "api/conductor/verify_pass"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "token " + conductorData["token"],
        },
        body: jsonEncode({
          "email": qrData["userDetails"]["email"],
          "to": "Thrissur",
          "from": "Angamaly",
          "busID": "10001",
          "passCode": qrData["busPassID"],
        }),
      );
      print(res.body);
      print(res.statusCode);

      if (res.statusCode != 200) {
        throw Exception("Operation failed: Status code not 200");
      }

      setState(() {
        isQrLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Image.asset(
                  "assets/conductor/tick.png",
                  width: 70,
                ),
                SizedBox(height: 40),
                Text(
                  "Pass Successfully verified",
                  style: TextStyle(color: primaryColor, fontSize: 14),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print("Error $e");
      alertDialog(text: "Pass verification failed", context: context);
    }
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
            var userData = snapshot.data;
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
                // HomeOptionCard(
                //   icon: Icons.travel_explore,
                //   onPressed: () {
                //     alertDialog(text: "Coming soon", context: context);
                //   },
                //   text: "Start Trip",
                // ),
                // HomeOptionCard(
                //   icon: Icons.history,
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       CupertinoPageRoute(
                //         builder: (context) => PreviousTrips(),
                //       ),
                //     );
                //   },
                //   text: "Trip History",
                // ),
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

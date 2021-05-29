import 'dart:convert';
import 'package:busapp/Screens/UserRegistration/userRegistration.dart';
import 'package:busapp/Screens/homepage.dart';
import 'package:busapp/Screens/userHomePage/Components/addBalance.dart';
import 'package:busapp/Screens/userHomePage/Components/refreshQr.dart';
import 'package:busapp/Screens/userHomePage/Components/reportComplaint.dart';
import 'package:busapp/Screens/userHomePage/Components/travelHistory.dart';
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/homeOptionCard.dart';
import 'package:busapp/Widgets/theme.dart';
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

  viewDetails(userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'User details',
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30),
            DetailTile(
              icon: Icons.account_circle,
              text: userData["userDetails"]["firstName"].toString() +
                  ' ' +
                  userData["userDetails"]["lastName"].toString(),
            ),
            DetailTile(
              icon: Icons.account_balance,
              text: "Account balance: " +
                  userData["userDetails"]["accBalance"].toString(),
            ),
            DetailTile(
              icon: Icons.phone,
              text: userData["userDetails"]["phoneNo"].toString(),
            ),
            DetailTile(
              icon: Icons.email,
              text: userData["userDetails"]["email"].toString(),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
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
      body: FutureBuilder(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = jsonDecode(snapshot.data);
            print(userData);
            return DefTemplate(
              showBackButton: true,
              topChildren: [
                SizedBox(height: 0),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(userData["picture"]),
                  radius: 40,
                ),
                SizedBox(height: 15),
                Text(
                  "Hey, " + userData["userDetails"]["firstName"].toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 20),
              ],
              bottomChildren: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      // Text(
                      //   userData.toString(),
                      // ),
                      QrImage(
                        data: userData.toString(),
                        version: QrVersions.auto,
                        size: 200.0,
                        foregroundColor: Color(0xff444444),
                      ),
                      SizedBox(height: 20),

                      SizedBox(height: 10),

                      HomeOptionCard(
                        icon: Icons.history,
                        onPressed: () {
                          viewDetails(userData);
                        },
                        text: "View user details",
                      ),
                      HomeOptionCard(
                        icon: Icons.history,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => UserTravelLog(),
                            ),
                          );
                        },
                        text: "View travel history",
                      ),
                      HomeOptionCard(
                        icon: Icons.money,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AddBalance(),
                            ),
                          );
                        },
                        text: "Add balance",
                      ),
                      HomeOptionCard(
                        icon: Icons.refresh,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RefreshQR(),
                            ),
                          );
                        },
                        text: "Refresh QR",
                      ),
                      HomeOptionCard(
                        icon: Icons.arrow_circle_up_sharp,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  UserRegistrationPage(updateProfile: true),
                            ),
                          );
                        },
                        text: "Update Profile",
                      ),
                      HomeOptionCard(
                        icon: Icons.system_update_alt,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ReportComplaint(),
                            ),
                          );
                        },
                        text: "Report Complaint",
                      ),
                      HomeOptionCard(
                        icon: Icons.history,
                        onPressed: () {
                          logout();
                        },
                        text: "Logout",
                      ),
                    ],
                  ),
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
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: lightBlack,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }
}

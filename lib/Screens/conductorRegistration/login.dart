import 'dart:convert';
import 'package:busapp/Screens/ConductorHomePage/conductorHomePage.dart';
import 'package:busapp/Screens/conductorRegistration/conductorRegistration.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:busapp/baseUrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConductorLogin extends StatefulWidget {
  @override
  _ConductorLoginState createState() => _ConductorLoginState();
}

class _ConductorLoginState extends State<ConductorLogin> {
  bool isLoading = false;
  String accessToken;

  var conductorData;
  conductorLogin() async {
    // Check offline data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get('coductorData');

    if (data != null) {
      print(data);
      print(jsonDecode(data));
      if (jsonDecode(data)["registered"] == true) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => ConductorHomePage(),
          ),
        );
        return;
      }
    }
// Login again
    setState(() {
      isLoading = true;
    });
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    await googleSignIn.signOut();
    GoogleSignInAccount accountInfo =
        await googleSignIn.signIn().onError((error, stackTrace) {
      Navigator.pop(context);
      alertDialog(text: "An error occured", context: context);
      return;
    });
    GoogleSignInAuthentication googleKeys = await accountInfo.authentication;
    accessToken = googleKeys.accessToken;
    print(accessToken);

    //  send data to backend

    var res = await http.post(
      Uri.parse(baseUrl + "api/conductor/login"),
      body: {
        "accessToken": accessToken,
      },
    );
    print(res.body);
    print(res.statusCode);
    var responseBody = jsonDecode(res.body);
    String token = responseBody["token"];
    print(token);
    await prefs.setString('coductorData', res.body);
    setState(() {
      isLoading = false;
    });
    if (responseBody["registered"] == false)
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => ConductrRegistration(),
        ),
      );
    else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => ConductorHomePage(),
        ),
      );
    }
  }

  @override
  void initState() {
    conductorData = conductorLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" "),
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      backgroundColor: primaryColor,
      body: FutureBuilder(
        future: conductorData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text("has data"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}

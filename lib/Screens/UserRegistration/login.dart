import 'dart:convert';
import 'package:busapp/Screens/userHomePage/userhomepage.dart';
import 'package:busapp/Screens/UserRegistration/userRegistration.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:busapp/baseUrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  bool isLoading = false;
  String accessToken;

  var userData;
  userLogin() async {
    // Check local data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get('userData');
    // If userdata present
    if (data != null) {
      if (jsonDecode(data)["registered"] == true) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => UserHomePage(),
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
    // Got access token
    print(
      jsonEncode(
        {
          "accessToken": accessToken,
        },
      ),
    );
    print("got access token");
    var res = await http.post(
      Uri.parse(baseUrl + "api/login"),
      body: {
        "accessToken": accessToken,
      },
    );
    print("finished thusss");
    print(res.body);
    print(res.statusCode);
    var responseBody = jsonDecode(res.body);
    String token = responseBody["token"];
    print(token);
    await prefs.setString('userData', res.body);
    setState(() {
      isLoading = false;
    });
    if (responseBody["registered"] == false)
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => UserRegistrationPage(),
        ),
      );
    else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => UserHomePage(),
        ),
      );
    }
  }

  @override
  void initState() {
    userData = userLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        backgroundColor: primaryColor,
        body: FutureBuilder(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Text("has data"),
              );
            } else {
              return Center(
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Center(),
              );
            }
          },
        ));
  }
}

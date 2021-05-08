import 'dart:convert';
import 'package:busapp/Screens/HomePage/homepage.dart';
import 'package:busapp/Screens/UserRegistration/userRegistration.dart';
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
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.get('userData');
    if (data != null) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      return;
    }
  }

  loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    await googleSignIn.signOut();
    GoogleSignInAccount accountInfo = await googleSignIn.signIn();
    GoogleSignInAuthentication googleKeys = await accountInfo.authentication;
    accessToken = googleKeys.accessToken;
    print(accessToken);
    setState(() {
      isLoading = false;
    });
    loginToBackend();
  }

  loginToBackend() async {
    setState(() {
      isLoading = true;
    });

    print(
      jsonEncode(
        {
          "accessToken": accessToken,
        },
      ),
    );
    var res = await http.post(
      Uri.parse("https://smart-bus-pass.herokuapp.com/api/login"),
      body: {
        "accessToken": accessToken,
      },
    );
    print(res.body);
    print(res.statusCode);
    var responseBody = jsonDecode(res.body);
    String token = responseBody["token"];
    print(token);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
    await prefs.setString('userData', jsonEncode(responseBody));
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
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  @override
  void initState() {
    userData = getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User Login"),
        ),
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
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          loginWithGoogle();
                        },
                        child: Text("Login"),
                      ),
              );
              // return Center(
              //   child: CircularProgressIndicator(),
              // );
            }
          },
        ));
  }
}

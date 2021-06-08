import 'dart:convert';
import 'package:busapp/Screens/userHomePage/userhomepage.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:busapp/baseUrl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshQR extends StatefulWidget {
  @override
  _RefreshQRState createState() => _RefreshQRState();
}

class _RefreshQRState extends State<RefreshQR> {
  bool isLoading = false;

  refreshQRCode() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = jsonDecode(prefs.get('userData'));
      var res = await http.get(
        Uri.parse(baseUrl + "api/refresh_qr"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "token " + userData["token"],
        },
      );
      print(res.body);
      print(res.statusCode);

      if (res.statusCode != 200) {
        throw Exception("Operation failed: Status code not 200");
      }

      await prefs.setString('userData', res.body);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => UserHomePage(),
        ),
      );
    } catch (e) {
      print("Error $e");
      alertDialog(text: "Operation Failed", context: context);
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefTemplate(
        showBackButton: true,
        topChildren: [
          Text(
            "Refresh QR Code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 20),
        ],
        bottomChildren: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .1),
            child: Center(
              child: Text(
                "Are u sure ?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff555555), fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 60),
          Icon(
            Icons.qr_code_scanner_rounded,
            size: 50,
            color: primaryColor,
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .1),
            child: Center(
              child: Text(
                "If you procceed, all previous QRCodes will be invalidated",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff555555), fontSize: 15),
              ),
            ),
          ),
          SizedBox(height: 100),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                )
              : Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: ElevatedButton(
                      onPressed: () {
                        refreshQRCode();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 15,
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child: Text("Refresh QR Code"),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

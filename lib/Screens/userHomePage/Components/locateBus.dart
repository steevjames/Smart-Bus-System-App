import 'dart:convert';
import 'package:busapp/Screens/userHomePage/Components/busLocation.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:busapp/baseUrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocateBus extends StatefulWidget {
  @override
  _LocateBusState createState() => _LocateBusState();
}

class _LocateBusState extends State<LocateBus> {
  bool isLoading = false;
  String busID;

  final _formKey = GlobalKey<FormState>();

  locateBus() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = jsonDecode(prefs.get('userData'));
      var res = await http.post(Uri.parse(baseUrl + "api/get_location"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "token " + userData["token"],
          },
          body: jsonEncode({
            "busID": busID,
          }));
      print(res.body);
      print(res.statusCode);
      setState(() {
        isLoading = false;
      });
      if (jsonDecode(res.body).isEmpty) {
        alertDialog(text: "No Location history exists", context: context);
        return;
      }
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => BusLocation(data: res.body),
        ),
      );
      if (res.statusCode != 200) {
        throw Exception("Operation failed: Status code not 200");
      }
    } catch (e) {
      print("Error $e");
      setState(() {
        isLoading = false;
      });
      alertDialog(text: "Operation Failed", context: context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefTemplate(
      showBackButton: true,
      topChildren: [
        Text(
          "Locate a Bus",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 20),
      ],
      bottomChildren: [
        SizedBox(height: 30),
        SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: Form(
            key: _formKey,
            child: TextFormField(
              onChanged: (value) => busID = value,
              validator: (val) {
                if (val == "") return "Enter a Value";
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Bus ID',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
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
                      locateBus();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 15,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: Text("Locate a Bus"),
                  ),
                ),
              ),
      ],
    );
  }
}

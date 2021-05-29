import 'dart:convert';
import 'package:busapp/Screens/ConductorHomePage/conductorHomePage.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConductrRegistration extends StatefulWidget {
  @override
  _ConductrRegistrationState createState() => _ConductrRegistrationState();
}

class _ConductrRegistrationState extends State<ConductrRegistration> {
  String firstName;
  String lastName;
  bool isStudent = false;
  String phoneNumber;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  submitDetails() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = jsonDecode(prefs.get('coductorData'))["token"];
    print(accessToken);
    try {
      var res = await http.post(
        Uri.parse(
            "https://smart-bus-pass.herokuapp.com/api/conductor/conductor_registration"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "token $accessToken",
        },
        body: jsonEncode(
          {
            'firstName': firstName,
            'lastName': lastName,
            'phoneNo': phoneNumber,
          },
        ),
      );
      print(res.body);
      print(res.statusCode);
      if (res.statusCode == 200) {
        await prefs.setString('coductorData', res.body);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => ConductorHomePage(),
          ),
        );
        return;
      } else {
        alertDialog(
            text: "Operation Failed, Check if data is valid", context: context);
      }
    } catch (e) {
      print("Error $e");
      alertDialog(text: "Something went wrong", context: context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conductor Registration"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              SizedBox(height: 30),
              TextFormField(
                onChanged: (value) {
                  firstName = value;
                },
                decoration: InputDecoration(labelText: "First name"),
                validator: (value) {
                  if (value.isEmpty) return "Enter first name";
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                onChanged: (value) {
                  lastName = value;
                },
                decoration: InputDecoration(labelText: "Last name"),
                validator: (value) {
                  if (value.isEmpty) return "Enter last name";
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                onChanged: (value) {
                  phoneNumber = value;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Phone number"),
                validator: (value) {
                  if (value.isEmpty) return "Enter phone number";
                  return null;
                },
              ),
              SizedBox(height: 50),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        submitDetails();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 15,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child: Text("Register as conductor"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

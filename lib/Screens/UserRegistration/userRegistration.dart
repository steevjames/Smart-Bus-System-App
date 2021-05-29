import 'dart:convert';
import 'package:busapp/Screens/userHomePage/userhomepage.dart';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserRegistrationPage extends StatefulWidget {
  final bool updateProfile;
  UserRegistrationPage({this.updateProfile = false});
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
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
    String accessToken = jsonDecode(prefs.get('userData'))["token"];
    print(accessToken);
    try {
      var res = await http.post(
        Uri.parse("https://smart-bus-pass.herokuapp.com/api/user_registration"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "token $accessToken",
        },
        body: jsonEncode(
          {
            'firstName': firstName,
            'lastName': lastName,
            'isStudent': isStudent,
            'phoneNo': phoneNumber,
          },
        ),
      );
      print(res.body);
      print(res.statusCode);
      if (res.statusCode == 200) {
        await prefs.setString('userData', res.body);

        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => UserHomePage(),
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
      // appBar: AppBar(
      //   title:
      //       Text(widget.updateProfile ? "Update profile" : "User Registration"),
      // ),
      body: Form(
        key: _formKey,
        child: DefTemplate(
          showBackButton: true,
          topChildren: [
            Text(
              widget.updateProfile ? "Update profile" : "User Registration",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
          ],
          bottomChildren: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
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
                  SizedBox(height: 25),
                  Text("Are you a student ?"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isStudent = true;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            isStudent ? primaryColor : Colors.white,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 15,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: isStudent ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isStudent = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            !isStudent ? primaryColor : Colors.white,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 15,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: !isStudent ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          child: ElevatedButton(
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
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            child: Text(
                              widget.updateProfile
                                  ? "Update Profile"
                                  : "Apply for Pass",
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

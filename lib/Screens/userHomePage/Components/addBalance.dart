import 'dart:convert';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:busapp/Screens/userHomePage/userhomepage.dart';
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:busapp/baseUrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBalance extends StatefulWidget {
  @override
  _AddBalanceState createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  String balance;
  String amount;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  addBalance() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = jsonDecode(prefs.get('userData'));
      var res = await http.post(Uri.parse(baseUrl + "api/add_balance"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "token " + userData["token"],
          },
          body: jsonEncode(amount));
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
    return DefTemplate(
      showBackButton: true,
      topChildren: [
        Text(
          "Add Balance",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 20),
      ],
      bottomChildren: [
        SizedBox(height: 20),
        Center(
          child: Text("Add balance to your account to travel."),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: Form(
            key: _formKey,
            child: TextFormField(
              onChanged: (value) {
                amount = value;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
              validator: (value) {
                if (value.length > 3) return "Maximum amount to add is 1000";
                if (value.isEmpty) return "Enter amount";
                return null;
              },
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
            : SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: ElevatedButton(
                  onPressed: () {
                    addBalance();
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
                  child: Text("Add balance"),
                ),
              ),
      ],
    );
  }
}

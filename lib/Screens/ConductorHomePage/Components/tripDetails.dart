import 'dart:convert';

import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripDetailsUpdation extends StatefulWidget {
  @override
  _TripDetailsUpdationState createState() => _TripDetailsUpdationState();
}

class _TripDetailsUpdationState extends State<TripDetailsUpdation> {
  String from;
  String destination;
  String busID;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  updateDetails() async {
    if (!_formKey.currentState.validate()) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tripData',
        jsonEncode({"from": from, "to": destination, "busID": busID}));

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Updated trip details",
        ),
        backgroundColor: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefTemplate(
      showBackButton: true,
      topChildren: [
        Text(
          "Update Trip Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 20),
      ],
      bottomChildren: [
        SizedBox(height: 15),
        SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    destination = value;
                  },
                  decoration: InputDecoration(labelText: "Destination"),
                  validator: (value) {
                    if (value.isEmpty) return "Enter Destination";
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  onChanged: (value) {
                    from = value;
                  },
                  decoration: InputDecoration(labelText: "Start Location"),
                  validator: (value) {
                    if (value.isEmpty) return "Enter Start Location";
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  onChanged: (value) {
                    busID = value;
                  },
                  decoration: InputDecoration(labelText: "Bus ID"),
                  validator: (value) {
                    if (value.isEmpty) return "Enter Bus ID";
                    return null;
                  },
                ),
              ],
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
                    updateDetails();
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
                  child: Text("Update Trip Details"),
                ),
              ),
        SizedBox(height: 20),
        TextButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove("tripData");
          },
          child: Text(
            "Clear Data",
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ],
    );
  }
}

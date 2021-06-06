import 'dart:convert';
import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:busapp/baseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportComplaint extends StatefulWidget {
  @override
  _ReportComplaintState createState() => _ReportComplaintState();
}

class _ReportComplaintState extends State<ReportComplaint> {
  bool isLoading = false;
  String complaint, busID;

  reportComplaint() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = jsonDecode(prefs.get('userData'));
      var res = await http.post(Uri.parse(baseUrl + "api/report_complaint"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "token " + userData["token"],
          },
          body: jsonEncode({
            "complaint": complaint,
            "busID": busID,
            "userID": userData["userDetails"]["email"],
          }));
      print(res.body);
      print(res.statusCode);

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

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Complaint Recieved",
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
          "Report a complaint",
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
          child: TextFormField(
            onChanged: (val) {
              busID = val;
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
        SizedBox(height: 15),
        SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: TextFormField(
            minLines: 5,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            onChanged: (val) {
              complaint = val;
            },
            decoration: InputDecoration(
              hintText: 'Add your complaint here',
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
                      reportComplaint();
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
                    child: Text("Report Complaint"),
                  ),
                ),
              ),
      ],
    );
  }
}

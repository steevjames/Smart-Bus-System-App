import 'package:busapp/Widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

class ReportComplaint extends StatefulWidget {
  @override
  _ReportComplaintState createState() => _ReportComplaintState();
}

class _ReportComplaintState extends State<ReportComplaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Complaint"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
              minLines: 2,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'description',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                alertDialog(text: "Coming Soon", context: context);
              },
              child: Text("Report complaint"),
            ),
          ],
        ),
      ),
    );
  }
}

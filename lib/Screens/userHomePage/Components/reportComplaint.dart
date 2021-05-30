import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';

class ReportComplaint extends StatefulWidget {
  @override
  _ReportComplaintState createState() => _ReportComplaintState();
}

class _ReportComplaintState extends State<ReportComplaint> {
  bool isLoading = false;

  reportComplaint() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Complaint Recieved",
        ),
        backgroundColor: Colors.blue,
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
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Add your complaint here',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                    child: Text("Refresh QR Code"),
                  ),
                ),
              ),
      ],
    );
  }
}

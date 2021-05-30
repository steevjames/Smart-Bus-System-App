import 'package:busapp/Widgets/defTemplate.dart';
import 'package:busapp/Widgets/theme.dart';
import 'package:flutter/material.dart';

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
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "QR Code has been successfully refreshed",
        ),
        backgroundColor: Colors.blue,
      ),
    );
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
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .1),
            child: Center(
              child: Text(
                "If you procceed, all materials using the previous QRCode will be invalidated",
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
